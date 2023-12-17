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
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;

namespace System.Workflow.Runtime
{
	class KeyedPriorityQueue<K, V, P> where V : class
	{
		private List<HeapNode<K, V, P>> heap = new List<HeapNode<K, V, P>>();
		private int size;
		private Comparer<P> priorityComparer = Comparer<P>.Default;
		private HeapNode<K, V, P> placeHolder = default(HeapNode<K, V, P>);
 
		public event EventHandler<KeyedPriorityQueueHeadChangedEventArgs<V>> FirstElementChanged;
 
		public KeyedPriorityQueue()
		{
			heap.Add(default(HeapNode<K, V, P>));       // Dummy zeroth element, heap is 1-based
		}
 
		public void Enqueue(K key, V value, P priority)
		{
			V oldHead = size > 0 ? heap[1].Value : null;
			int i = ++size;
			int parent = i / 2;
			if (i == heap.Count)
				heap.Add(placeHolder);
			while (i > 1 && IsHigher(priority, heap[parent].Priority))
			{
				heap[i] = heap[parent];
				i = parent;
				parent = i / 2;
			}
			heap[i] = new HeapNode<K, V, P>(key, value, priority);
			V newHead = heap[1].Value;
			if (!newHead.Equals(oldHead))
			{
				RaiseHeadChangedEvent(oldHead, newHead);
			}
		}
 
		public V Dequeue()
		{
			V oldHead = (size < 1) ? null : DequeueImpl();
			V newHead = (size < 1) ? null : heap[1].Value;
			RaiseHeadChangedEvent(null, newHead);
			return oldHead;
		}
 
		private V DequeueImpl()
		{
			Debug.Assert(size > 0, "Queue Underflow");
			V oldHead = heap[1].Value;
			heap[1] = heap[size];
			heap[size--] = placeHolder;
			Heapify(1);
			return oldHead;
		}
 
 
		public V Remove(K key)
		{
			if (size < 1)
				return null;
 
			V oldHead = heap[1].Value;
			for (int i = 1; i <= size; i++)
			{
				if (heap[i].Key.Equals(key))
				{
					V retval = heap[i].Value;
					Swap(i, size);
					heap[size--] = placeHolder;
					Heapify(i);
					V newHead = heap[1].Value;
					if (!oldHead.Equals(newHead))
					{
						RaiseHeadChangedEvent(oldHead, newHead);
					}
					return retval;
				}
			}
			return null;
		}
 
		public V Peek()
		{
			return (size < 1) ? null : heap[1].Value;
		}
 
		public int Count
		{
			get { return size; }
		}
 
		public V FindByPriority(P priority, Predicate<V> match)
		{
			return size < 1 ? null : Search(priority, 1, match);
		}
 
		public ReadOnlyCollection<V> Values
		{
			get
			{
				List<V> values = new List<V>();
				for (int i = 1; i <= size; i++)
				{
					values.Add(heap[i].Value);
				}
				return new ReadOnlyCollection<V>(values);
			}
		}
 
		public ReadOnlyCollection<K> Keys
		{
			get
			{
				List<K> keys = new List<K>();
				for (int i = 1; i <= size; i++)
				{
					keys.Add(heap[i].Key);
				}
				return new ReadOnlyCollection<K>(keys);
			}
		}
 
		public void Clear()
		{
			heap.Clear();
			size = 0;
		}
 
		private void RaiseHeadChangedEvent(V oldHead, V newHead)
		{
			if (oldHead != newHead)
			{
				EventHandler<KeyedPriorityQueueHeadChangedEventArgs<V>> fec = FirstElementChanged;
				if (fec != null)
					fec(this, new KeyedPriorityQueueHeadChangedEventArgs<V>(oldHead, newHead));
			}
		}
 
		private V Search(P priority, int i, Predicate<V> match)
		{
			Debug.Assert(i >= 1 || i <= size, "Index out of range: i = " + i + ", size = " + size);
 
			V value = null;
			if (IsHigher(heap[i].Priority, priority))
			{
				if (match(heap[i].Value))
					value = heap[i].Value;
				int left = 2 * i;
				int right = left + 1;
				if (value == null && left <= size)
					value = Search(priority, left, match);
				if (value == null && right <= size)
					value = Search(priority, right, match);
			}
			return value;
		}
 
		private void Heapify(int i)
		{
			Debug.Assert(i >= 1 || i <= size, "Index out of range: i = " + i + ", size = " + size);
 
			int left = 2 * i;
			int right = left + 1;
			int highest = i;
			if (left <= size && IsHigher(heap[left].Priority, heap[i].Priority))
				highest = left;
			if (right <= size && IsHigher(heap[right].Priority, heap[highest].Priority))
				highest = right;
			if (highest != i)
			{
				Swap(i, highest);
				Heapify(highest);
			}
 
		}
 
		private void Swap(int i, int j)
		{
			Debug.Assert(i >= 1 || j >= 1 || i <= size || j <= size, "Index out of range: i = " + i + ", j = " + j + ", size = " + size);
 
			HeapNode<K, V, P> temp = heap[i];
			heap[i] = heap[j];
			heap[j] = temp;
		}
 
		protected virtual bool IsHigher(P p1, P p2)
		{
			return (priorityComparer.Compare(p1, p2) < 1);
		}
 
		[Serializable]
		private struct HeapNode<KK, VV, PP>
		{
			public KK Key;
			public VV Value;
			public PP Priority;
 
			public HeapNode(KK key, VV value, PP priority)
			{
				Key = key;
				Value = value;
				Priority = priority;
			}
		}
	}
}
