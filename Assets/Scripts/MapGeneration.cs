using System;
using UnityEngine;

public class MapGeneration : MonoBehaviour{

    public Sprite grass;
    public Sprite river;
    public Transform tileContainer;


    int mapSize = 32;
    int[,] map = new int[32, 32];



    void Start(){
        for (int i = 0; i < mapSize; i++){
            for (int j = 0; j < mapSize; j++){
                Vector2 position = new Vector2(i,j);
                Spawn(position, grass);
            }
        }
    }

    void Update(){

    }

    void Spawn(Vector2 position, Sprite sprite){
        GameObject obj = new GameObject("Tile");
        obj.transform.position = position;
        obj.transform.SetParent(tileContainer);
        SpriteRenderer sr = obj.AddComponent<SpriteRenderer>();
        sr.sprite = sprite;
    }

}
