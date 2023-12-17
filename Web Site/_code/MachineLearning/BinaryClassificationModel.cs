/**********************************************************************************************************************
 * SplendidCRM is a Customer Relationship Management program created by SplendidCRM Software, Inc. 
 * Copyright (C) 2005-2023 SplendidCRM Software, Inc. All rights reserved.
 *
 * Any use of the contents of this file are subject to the SplendidCRM Enterprise Source Code License 
 * Agreement, or other written agreement between you and SplendidCRM ("License"). By installing or 
 * using this file, you have unconditionally agreed to the terms and conditions of the License, 
 * including but not limited to restrictions on the number of users therein, and you may not use this 
 * file except in compliance with the License. 
 * 
 * SplendidCRM owns all proprietary rights, including all copyrights, patents, trade secrets, and 
 * trademarks, in and to the contents of this file.  You will not link to or in any way combine the 
 * contents of this file or any derivatives with any Open Source Code in any manner that would require 
 * the contents of this file to be made available to any third party. 
 * 
 * IN NO EVENT SHALL SPLENDIDCRM BE RESPONSIBLE FOR ANY DAMAGES OF ANY KIND, INCLUDING ANY DIRECT, 
 * SPECIAL, PUNITIVE, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES.  Other limitations of liability 
 * and disclaimers set forth in the License. 
 * 
 *********************************************************************************************************************/
using System;
using System.IO;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Reflection.Emit;
using System.Data;
using System.Data.Common;
using System.Diagnostics;

using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using Microsoft.ML.Transforms;

namespace SplendidCRM.MachineLearning
{
	public class OutputModel
	{
		public bool PredictedLabel;

		public float Score;

		public float Probability;
	}

	public class BinaryClassificationModel
	{
		private readonly MLContext _mlContext;

		private IDataView _allData;

		private ITransformer _model;

		private OutputModel _results;

		private readonly string _labelColumn;
		private DataTable _dataTable;
		private Type _generatedType;

		private object _engine;
		private MethodBase _predictMethod;
		private FieldAwareFactorizationMachineTrainer.Options _options;

		public BinaryClassificationModel(DataTable dataTable, string labelColumn)
		{
			_mlContext = new MLContext();
			_dataTable = dataTable;
			_labelColumn = labelColumn;
			_generatedType = GenerateTypeFromDataTable(dataTable);
		}

		public void LoadData()
		{
			_allData = ProcessDataTable(_dataTable);
		}

		// Converts DataTable into generic IEnumerable then converts it into an IDataView.
		// IDataView is used to pass data into the trainer
		private IDataView ProcessDataTable(DataTable table)
		{
			var listType = typeof(List<>).MakeGenericType(_generatedType);

			var list = Activator.CreateInstance(listType);

			for (var i = 0; i < table.Rows.Count; i++)
			{
				var row = table.Rows[i];
				var record = Activator.CreateInstance(_generatedType);
				for (var j = 0; j < table.Columns.Count; j++)
				{
					var column = table.Columns[j];
					var property = _generatedType.GetField(column.ColumnName);
					var value = row[column.ColumnName];
					if (value is DBNull) continue;

					//Guids are not an allowed type
					if (value is Guid)
						property.SetValue(record, value.ToString());
					else
						property.SetValue(record, value);
				}

				listType
					.GetMethod("Add")
					.Invoke(list, new[] {record});
			}

			var schemaDefinition = SchemaDefinition.Create(_generatedType);

			return typeof(DataOperationsCatalog)
				.GetMethods()
				.First(x => x.Name == "LoadFromEnumerable" && x.GetParameters()[1].IsOptional)
				.MakeGenericMethod(_generatedType)
				.Invoke(_mlContext.Data, new object[]
				{
					list,
					schemaDefinition
				}) as IDataView;
		}

		// Generates dynamic type from the DataTable
		private Type GenerateTypeFromDataTable(DataTable table)
		{
			var assemblyName = new AssemblyName(Assembly.GetAssembly(typeof(BinaryClassificationModel)).FullName ?? "" + "Dynamic");
			var assemblyBuilder = AssemblyBuilder.DefineDynamicAssembly(assemblyName, AssemblyBuilderAccess.Run);
			var module = assemblyBuilder.DefineDynamicModule(assemblyName.Name + ".dll");
			var typeBuilder = module.DefineType("DynamicInputModel", TypeAttributes.Public);
			for (var i = 0; i < table.Columns.Count; i++)
			{
				var column = table.Columns[i];
				var columnType = column.DataType == typeof(Guid)
					? typeof(string)
					: column.DataType;
				typeBuilder.DefineField(column.ColumnName, columnType, FieldAttributes.Public);
			}

			return typeBuilder.CreateType();
		}


		// Builds and Trains the model
		public void Train(bool useCrossValidation = false)
		{
			//Console.WriteLine("Building");

			// Options to configure our Trainer
			// Higher iterations and lower learning rates improve accuracy but increase training time
			_options = new FieldAwareFactorizationMachineTrainer.Options
			{
				Shuffle = true,
				NumberOfIterations = 1000,
				LatentDimension = 50,
				LearningRate = .001f,
				LabelColumnName = _labelColumn,
				FeatureColumnName = "Features"
			};


			// Convert the data columns into vectors that the AI can work with
			var pairs = new List<InputOutputColumnPair>();
			for (var i = 0; i < _dataTable.Columns.Count; i++)
			{
				var columnName = _dataTable.Columns[i].ColumnName;
				if (columnName == _labelColumn)
					continue;
				pairs.Add(new InputOutputColumnPair(columnName + "OneHot", columnName));
			}

			var featureColumnNames = pairs.Select(x => x.OutputColumnName).ToArray();

			var pipeline = _mlContext.Transforms.Categorical.OneHotEncoding(pairs.ToArray())
				.Append(_mlContext.Transforms.Concatenate("Features", featureColumnNames))
				.Append(_mlContext.BinaryClassification.Trainers.FieldAwareFactorizationMachine(_options));

			// Pass our data through the pipeline to train the model
			//Console.WriteLine("Training");

			if (!useCrossValidation)
			{
				_model = pipeline.Fit(_allData);
				return;
			}

			var cvResults = _mlContext.BinaryClassification.CrossValidate(_allData, pipeline, 3, _labelColumn);
			var bestFold = cvResults
				.OrderByDescending(fold => fold.Metrics.Accuracy)
				.First();

			_model = bestFold.Model;

			//Console.WriteLine(PrintObject(bestFold.Metrics));
		}

		// Evaluate the accuracy of our model by passing valid records through it.
		// Do not pass any records used to train the model since it already knows what their values should be.
		public CalibratedBinaryClassificationMetrics Evaluate(DataTable table)
		{
			IDataView testData   = ProcessDataTable(table);
			IDataView scoredData = _model.Transform(testData);
			CalibratedBinaryClassificationMetrics metrics = _mlContext.BinaryClassification.Evaluate(scoredData, _labelColumn, "Score", "Probability", "PredictedLabel");
			return metrics;
		}

		// Predict the result of a record
		public OutputModel Predict(DataRow row)
		{
			//Create a PredictionEngine with our generated type for our model
			if (_engine == null)
				_engine = typeof(ModelOperationsCatalog)
					.GetMethods()
					.First(x => x.Name == "CreatePredictionEngine" &&
								x.GetParameters()[1].IsOptional)
					.MakeGenericMethod(_generatedType, typeof(OutputModel))
					.Invoke(_mlContext.Model, new object[]
					{
						_model,
						true,
						null,
						null
					});


			//Create an instance of our generated type
			//Then set its values
			var record = ConvertRow(row);

			if (_predictMethod == null)
				_predictMethod = _engine.GetType()
					.GetMethods()
					.First(x => x.Name == "Predict" && x.ReturnType == typeof(OutputModel));

			//Run the Predict method on our PredictionEngine
			_results = _predictMethod.Invoke(_engine, new[]
			{
				record
			}) as OutputModel;

			return _results;
		}

		private object ConvertRow(DataRow record)
		{
			var data = Activator.CreateInstance(_generatedType);

			for (var i = 0; i < record.Table.Columns.Count; i++)
			{
				var column = record.Table.Columns[i];
				if (column.ColumnName == _labelColumn)
					continue;
				var property = _generatedType.GetField(column.ColumnName);
				var value = record[column.ColumnName];
				if (value is DBNull)
					continue;
				property.SetValue(data, value is Guid
					? value.ToString()
					: value);
			}

			return data;
		}

		public void Save(Stream stream)
		{
			_mlContext.Model.Save(_model, _allData.Schema, stream);
		}

		public void Load(Stream stream)
		{
			DataViewSchema inputSchema = null;
			_model = _mlContext.Model.Load(stream, out inputSchema);
		}
	}
}

