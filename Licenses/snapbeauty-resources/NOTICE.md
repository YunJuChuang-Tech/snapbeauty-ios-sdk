# 滤镜 LUT 来源、署名与改动说明

本批 17 张滤镜基于开放许可 LUT，经重采样、量化以及强度、提亮、冷暖、色调、饱和度和对比度调整后烘焙。逐项来源和许可见下表及 manifest.json。

## Q-DDL

署名：**Q-DDL Free Color LUTs (quickddl.net)**。
原站 http://quickddl.net/free_color_luts 已关闭；取得途径为 https://www.photoshoplus.fr/telecharger-luts-2/ 的镜像包。
许可依据为原站网页存档：https://web.archive.org/web/20201130011410/https://quickddl.net/free_color_luts/ ，其声明 **CC BY 4.0**：https://creativecommons.org/licenses/by/4.0/ 。
原始存档HTML及所用包README保存在 upstream/；README同时声明可用于个人或商业项目。完整CC BY 4.0原文在 resources/licenses/CC-BY-4.0.txt。
上述重采样、量化、六参数调整由本项目完成；对应LUT按CC BY 4.0提供，保留来源、署名及改动记录，不暗示原作者背书。

## 逐项对应

| SDK文件 | 基础素材 | 许可 |
| --- | --- | --- |
| bright1.png | color-grading/Q-DDL_Pack_9/Horn.cube | CC-BY-4.0 |
| bright2.png | film-simulation/Q-DDL_Pack_14/Oconnor.cube | CC-BY-4.0 |
| bright4.png | color-moods/Q-DDL_Pack_20/Case.cube | CC-BY-4.0 |
| rose1.png | color-moods/Q-DDL_Pack_16/Stewart.cube | CC-BY-4.0 |
| rose2.png | cinematic/Q-DDL_Pack_3/French.cube | CC-BY-4.0 |
| rose7.png | cinematic/Q-DDL_Pack_4/Alexander.cube | CC-BY-4.0 |
| rose8.png | film-simulation/Q-DDL_Pack_14/Sweeney.cube | CC-BY-4.0 |
| stylized5.png | cinematic/Q-DDL_Pack_5/Dodson.cube | CC-BY-4.0 |
| cool1.png | film-simulation/Q-DDL_Pack_15/Ritter.cube | CC-BY-4.0 |
| cool11.png | film-simulation/Q-DDL_Pack_14/Navarro.cube | CC-BY-4.0 |
| cool4.png | color-grading/Q-DDL_Pack_8/Leonard.cube | CC-BY-4.0 |
| peach1.png | color-moods/Q-DDL_Pack_18/Christensen.cube | CC-BY-4.0 |
| peach5.png | color-moods/Q-DDL_Pack_17/King.cube | CC-BY-4.0 |
| fresh2.png | cinematic/Q-DDL_Pack_3/York.cube | CC-BY-4.0 |
| fresh3.png | color-moods/Q-DDL_Pack_20/Pena.cube | CC-BY-4.0 |
| muted1.png | film-simulation/Q-DDL_Pack_11/Thompson.cube | CC-BY-4.0 |
| natural1.png | color-moods/Q-DDL_Pack_17/Luna.cube | CC-BY-4.0 |

存储格式：RGB8 64³ 结果三线性采样到 16³ 并量化，按 256×16 蓝切片横排。
