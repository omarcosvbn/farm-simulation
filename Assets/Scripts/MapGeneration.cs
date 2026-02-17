
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
        Forest(10, new Vector2(15, 15));

        
        for (int i = 0; i < mapSize; i++){
            for (int j = 0; j < mapSize; j++){
                Vector2 position = new Vector2(i,j);
                if(map[i,j] == 0) Spawn(position, grass);
                else if(map[i,j] == 2) Spawn(position, tree);
            }
        }
    }

    void Update(){
    }

    void Spawn(Vector2 position, Sprite sprite){
        GameObject obj = new GameObject("Tile");
        obj.transform.SetParent(tileContainer);
        obj.transform.localPosition = position;
        SpriteRenderer sr = obj.AddComponent<SpriteRenderer>();
        sr.sprite = sprite;
    }

    void Forest(int maxTrees, Vector2 startPoint){
        int count = 0;
        Vector2 lastPoint = startPoint;
        map[(int)lastPoint.x, (int)lastPoint.y] = 2;

        while (count < maxTrees - 1){
            // check if the first index of map is equal
            if(Random.Range(0, 2) == 0){
                // check if the second index of map -1 or +1
                if(Random.Range(0, 2) == 0){
                    map[(int)lastPoint.x, (int)lastPoint.y - 1] = 2;
                    lastPoint = new Vector2(lastPoint.x, lastPoint.y - 1);
                }
                else{
                    map[(int)lastPoint.x, (int)lastPoint.y + 1] = 2;
                    lastPoint = new Vector2(lastPoint.x, lastPoint.y + 1);
                }
            }
            else{
                if(Random.Range(0, 2) == 0){
                    map[(int)lastPoint.x - 1, (int)lastPoint.y] = 2;
                    lastPoint = new Vector2(lastPoint.x - 1, lastPoint.y);
                }
                else{
                    map[(int)lastPoint.x + 1, (int)lastPoint.y] = 2;
                    lastPoint = new Vector2(lastPoint.x + 1, lastPoint.y);
                }
            }

            count++;
        }
    }

}
