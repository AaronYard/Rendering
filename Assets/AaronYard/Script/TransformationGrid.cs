using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TransformationGrid : MonoBehaviour {

	// Use this for initialization
	public Transform prefab;
	public int girdResolution = 10;
	Transform[] grid;

	List<Transformation> transformations;
	void Awake()
	{
		//创建点的三维网格
		grid = new Transform[girdResolution * girdResolution * girdResolution];
		for(int i = 0,z=0;z< girdResolution;z++)
			for (int y = 0; y < girdResolution; y++)
				for (int x = 0; x < girdResolution; x++, i++)
				{
					grid[i] = CreateGridPoint(x, y, z);
				}

		transformations = new List<Transformation>();
	}
	//实例化一个预制件、确定它的坐标，并给它一个独特的颜色。
	Transform CreateGridPoint(int x, int y, int z)
	{
		Transform point = Instantiate<Transform>(prefab);
		point.localPosition = GetCoordinares(x, y, z);
		point.GetComponent<MeshRenderer>().material.color = new Color(
			(float)x / girdResolution,
			(float)y / girdResolution,
			(float)z / girdResolution
			);
		return point;
	}
	//设置位置
	Vector3 GetCoordinares(int x, int y, int z)
	{
		return new Vector3(
			x - (girdResolution - 1) * 0.5f,
			y - (girdResolution - 1) * 0.5f,
			z - (girdResolution - 1) * 0.5f
			);
	}

	void Update() {
		GetComponents<Transformation>(transformations);
		for (int i = 0, z = 0; z < girdResolution; z++)
			for (int y = 0; y < girdResolution; y++)
				for (int x = 0; x < girdResolution; x++, i++)
				{
					grid[i].localPosition = TransformPoint(x, y, z);
				}
	}

	Vector3 TransformPoint(int x, int y, int z)
	{
		Vector3 coordinates = GetCoordinares(x, y, z);
		for(int i = 0; i < transformations.Count; i++)
		{
			coordinates = transformations[i].Apply(coordinates);
		}
		return coordinates;
	}
}
