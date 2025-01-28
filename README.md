# IMU Vibration Detection and Compensation Project

This repository focuses on detecting and compensating for vibrations in non-ideal IMU (Inertial Measurement Unit) data. The study combines signal processing, machine learning, and deep learning techniques in MATLAB, inspired by the [MATLAB-Simulink Challenge Project Hub](https://github.com/mathworks/MATLAB-Simulink-Challenge-Project-Hub/tree/main/projects/Vibration%20Detection%20and%20Rejection%20from%20IMU%20Data) (Project #231).
This file is for general overview. Detailed information about the project can be accessed in `Report/report.pdf` file.

## Contributors
- **Buket ÖZBAY** - [ozbayb21@itu.edu.tr](mailto:ozbayb21@itu.edu.tr), **Deniz ERDOĞAN** - [erdogand21@itu.edu.tr](mailto:erdogand21@itu.edu.tr)
For any comment or recommendation, please contact us.

---

## Order of Execution
To reproduce the study results, execute the following scripts in order:

1. `data_generation.m`  
2. `kmeans_classification.m`  
3. `vibration_comp_DL.m`

Note: `moving_imu.m` file is only for understanding the IMU behavior in motion. Therefore, it does not necessarily need to be installed to run the project.

---

## Project Objective
Vibrations caused by engines or environmental factors can negatively affect accelerometer and gyroscope data, degrading a vehicle's navigation accuracy. This project aims to:

- Analyze vibration signals using time and frequency domain techniques.
- Generate synthetic vibration data for training machine learning models.
- Classify vibration data using clustering algorithms.
- Compensate for vibrations using deep learning-based denoising.

By improving the detection and compensation of vibrations, the study contributes to designing more reliable navigation systems.

---

## Workflow

### 1. **Dataset Examination and Vibration Analysis**
The initial step involved analyzing the Kaggle dataset: *Accelerometer Data Set for Prediction of Motor Failure Time*. It can be found in `Dataset` folder. Key analyses:

- **Time-Domain Analysis:** Studied acceleration signal behavior over time.
- **Frequency-Domain Analysis:** Employed Fast Fourier Transform (FFT) to identify vibration characteristics:
  - **X-Axis:** Dominated by low frequencies; static or low-frequency vibrations were negligible. This axis was excluded.
  - **Y-Axis:** A significant peak around 15 Hz indicated mechanical resonance or a vibration source.
  - **Z-Axis:** Moderate peaks observed in the 10–15 Hz range, suggesting medium-frequency vibrations.

### 2. **Vibration Data Generation**
Artificial vibration data was created using signal processing techniques. The generated signals exhibited high amplitudes at specific frequencies, closely matching observed vibrations in the dataset.

### 3. **Vibration Detection with K-Means Clustering**
The K-means algorithm, an unsupervised machine learning technique, was employed to classify data into:
- Vibrating
- Non-vibrating

Clusters were determined based on RMS values, providing a simple yet effective way to distinguish between these states.

### 4. **Vibration Compensation Using a Denoising Autoencoder**
A denoising autoencoder was implemented to reduce vibration effects in IMU data. The process involves:

- **Input Data:**
  - Clean data: Original, vibration-free signals.
  - Corrupted data: Signals with added noise.
  - Noisy input (~): Given to the autoencoder for denoising.

- **Model Architecture:**
  - **Encoder (gφ):** Compresses input data to a lower-dimensional representation.
  - **Bottleneck (z):** Stores compressed features.
  - **Decoder (fθ):** Reconstructs data to its original dimensions.

- **Output:** Reconstructed data (χ') approximates clean data (χ).

---

## Key Findings
- **Frequency Analysis:** FFT provided crucial insights for identifying vibration sources and system behavior.
- **Feature Extraction:** RMS and amplitude values effectively distinguished vibration states.
- **Classification:** K-means successfully categorized data into vibrating and non-vibrating clusters.
- **Vibration Compensation:** Deep learning techniques effectively removed vibration artifacts, improving data reliability.

---

## Future Work
To enhance data generation, generative AI techniques such as GANs will replace signal processing methods. This approach will expand the dataset and improve model training.
