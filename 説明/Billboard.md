#ビルボード
###概要
- ParticleSystemのような
- 常にカメラの方向を向いているポリゴン

###実現方法
####CPUで実現する
- transform.LookAt(targetCamera.transform.position);
- [meshを生成](http://docs.unity3d.com/ja/current/Manual/Example-CreatingaBillboardPlane.html)（毎フレームやると重い！！）

####GPUで実現する
- [定義済みシェーダー変数](http://docs.unity3d.com/ja/current/Manual/SL-UnityShaderVariables.html)
- UNITY\_MATRIX\_MVP

#####現在のモデル\*ビュー\*射影行列
- o.pos = mul(UNITY\_MATRIX\_MVP, v.vertex);
- オブジェクト座標→ワールド座標→カメラ座標→プロジェクション座標
- 変換行列を３つ掛け合わせたもの
- オブジェクト座標→ワールド座標への変換鋲列(_Object2World)
- ワールド座標→カメラ座標への変換行列(UNITY\_MATRIX\_V)
- カメラ座標→プロジェクション座標への変換行列(Unity\_MATRIX\_P)
- オブジェクト座標→カメラ座標(UNITY\_MATRIX\_MV)というのが、ある！

###ビルボードを頂点シェーダで実装する
- デフォルトの、Quadのメッシュオブジェクトを使う！