# SnapBeauty SDK 第三方声明

本文件随 SDK 发布包分发，只列出发布包实际包含的第三方内容。

## 人脸模型

- `snapbeauty/face_detector.tflite`、`snapbeauty/face_landmarks_detector.tflite`
  来源：Google MediaPipe Face Landmarker 模型包 face_landmarker.task（float16/1）
  https://storage.googleapis.com/mediapipe-models/face_landmarker/face_landmarker/float16/1/face_landmarker.task
  许可：Apache License 2.0（https://www.apache.org/licenses/LICENSE-2.0）

## 推理运行时

静态链接 TensorFlow Lite 2.16.1 C API、XNNPACK 与 GPU delegate 及其构建依赖。
TensorFlow Lite 为 Apache-2.0；依赖还包含 BSD、MIT、Eigen（MPL-2.0）与 Ooura FFT 的原始许可，
不能一概视为 Apache-2.0。Android AAR 在 `classes.jar` 的 `META-INF/THIRD-PARTY-NOTICES.txt`
附各依赖原始 LICENSE / COPYING / NOTICE 及来源清单。

## JSON 解析

nlohmann/json 3.11.3，MIT。Android AAR 的 `META-INF/THIRD-PARTY-NOTICES.txt` 附原始许可证与来源信息。

## 离线授权验签

Monocypher 4.0.2（Ed25519 / SHA-512），BSD-2-Clause 或 CC0-1.0 双许可。
源码：https://github.com/LoupVaillant/Monocypher/tree/4.0.2 。随包附原始许可：
Android `META-INF/THIRD-PARTY-NOTICES.txt`，iOS / HarmonyOS `Licenses/Monocypher.txt`。

## 滤镜 LUT

17 张风格滤镜由开放许可 LUT 重采样、量化并经六个全局参数调整后烘焙：

- Q-DDL Free Color LUTs（quickddl.net），CC BY 4.0。

Android AAR 的 `META-INF/THIRD-PARTY-NOTICES.txt` 收录逐项来源、署名、改动与许可全文。署名不表示原作者背书。

## 其他效果资源

美白、红润、清晰、口红亮度、眼部提亮、牙齿美白等曲线与查找表，五官遮罩、美型位移模板和腮红
UV 由本项目按公式或公开的 MediaPipe canonical 人脸几何生成（Apache-2.0，原文见
Android `META-INF/THIRD-PARTY-NOTICES.txt`）。
部分资源经过参数调整。

## 不随 SDK 分发的内容

妆容贴图与唇色由接入方按 `makeup/<层>/<层>_NN` 约定自行提供，不包含在 SDK 中，
其许可由提供方负责。
