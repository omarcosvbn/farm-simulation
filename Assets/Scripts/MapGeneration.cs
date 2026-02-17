using System.Collections.Generic;
using UnityEngine;

public class MapGeneration : MonoBehaviour{


///////////////////////////
    public Sprite grass;
    public Sprite river;
    public Sprite tree;
    public Transform tileContainer;

///////////////////////////
    int mapSize = 32;
    int[,] map;

///////////////////////////

    void Awake(){
        map = new int[mapSize, mapSize];
    }

    void Start(){
        Forest(15, new Vector2Int(15, 15));

        
        for (int i = 0; i < mapSize; i++){
            for (int j = 0; j < mapSize; j++){
                Vector2 position = new Vector2(i,j);
                if(map[i,j] == 0) Spawn(position, grass);
                else if(map[i,j] == 2) Spawn(position, tree);
            }
        }
    }

    void Update()
    {
        Debug.Log(Vector2Int.up);
    }

    void Spawn(Vector2 position, Sprite sprite){
        GameObject obj = new GameObject("Tile");
        obj.transform.SetParent(tileContainer);
        obj.transform.localPosition = position;
        SpriteRenderer sr = obj.AddComponent<SpriteRenderer>();
        sr.sprite = sprite;
    }

    void Forest(int maxTrees, Vector2Int startPoint){
        List<Vector2Int> forestTiles = new List<Vector2Int>();

        map[startPoint.x, startPoint.y] = 2;
        forestTiles.Add(startPoint);

        int count = 1;

        while (count < maxTrees){
            Vector2Int baseTile = forestTiles[Random.Range(0, forestTiles.Count)];

            Vector2Int direction = Vector2Int.zero;
            int dir = Random.Range(0, 4);

            switch (dir){
                case 0: direction = Vector2Int.up; break;
                case 1: direction = Vector2Int.down; break;
                case 2: direction = Vector2Int.left; break;
                case 3: direction = Vector2Int.right; break;
            }

            Vector2Int newTile = baseTile + direction;

            if (newTile.x >= 0 && newTile.x < mapSize && newTile.y >= 0 && newTile.y < mapSize){
                if (map[newTile.x, newTile.y] != 2){
                    map[newTile.x, newTile.y] = 2;
                    forestTiles.Add(newTile);
                    count++;
                }
            }
        }
    }
}
