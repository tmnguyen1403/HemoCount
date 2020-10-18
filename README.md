## Demo Hemocount

![Demo](./Gif/demo3.gif)

## Inspiration

The sudden and rapid growth of COVID-19 cases is overwhelming health systems globally. Consequently, the need for fast and accurate early detection of SARS-CoV-2 has become of vital importance to control the spread of the virus. However, traditional SARS-CoV-2 detection based on RT-PCR assays are costly, long-drawn-out and widely unavailable; thus, rendering its large-scale implementation impractical. 

From an analysis on 5644 patients (with 558 tested positive for SARS-CoV-2) from the Hospital Israelita Albert Einstein in São Paulo, Brazil, results reveal that patients admitted with COVID-19 symptoms who tested negative for Rhinovirus Enterovirus, Influenza B & Inf.A.H1N1.2009 and presented low levels of Leukocytes and Platelets were more likely to test positive for SARS-CoV-2. (Souza, 2020). 

In this work, we propose a deep learning-based approach for the rapid detection of COVID-19 cases using commonly available laboratory data of thin blood smears to count the number of Leukocytes and Platelets. Due to time constraint for this Datathon, we are only able to finish the deep learning model to count Leukocytes or white blood cells (WBC). 

## What it does

In the manual approach, a sample of blood is placed under a microscope and a pathologist manually counts the number of cells in each frame. The total count is then extrapolated by assuming that the distribution is uniform across the entire blood sample and multiplying up.

Our HemoCount platform harnesses deep learning methods to classify four types of white blood cells: Eosinophil, Lymphocyte, Monocyte and Neutrophil. Then, it counts the number of white blood cell occurrences in a blood smear

The primary advantages of this approach are two-fold:

* It requires far cheaper equipment  (which will substantially reduce the cost for testing) and
* It provides rapid result on a large scale of blood cell counting almost instantly.

Below, we can see a potential time-saving effect of our AI-based platform vs the manual process:![Alt text](https://challengepost-s3-challengepost.netdna-ssl.com/photos/production/software_photos/001/251/711/datas/original.png)


## How we built it

**Dataset:**

This dataset contains 12,500 augmented images of various types of white blood cells (JPEG) with metadata in CSV form. That includes 3,000 images divided into 4 different white blood cell types (classes). We split train-test on 80-20 ratio for each of the classes. 

Source: https://www.kaggle.com/paultimothymooney/blood-cells
![Alt text](https://challengepost-s3-challengepost.netdna-ssl.com/photos/production/software_photos/001/251/824/datas/original.png)

**Training process:**



After loading the images, we preprocess the data using image augmentation:
![Alt text](https://challengepost-s3-challengepost.netdna-ssl.com/photos/production/software_photos/001/251/823/datas/original.png)

For this project, we used transfer learning on a pretrained Resnet34 model with a slight modification to its last layer to attain an output of 4 classes.![Alt text](https://challengepost-s3-challengepost.netdna-ssl.com/photos/production/software_photos/001/251/821/datas/original.png)

We used fasati's  ```lr_find()``` function to explore the best learning rate for our model.
![Alt text](https://challengepost-s3-challengepost.netdna-ssl.com/photos/production/software_photos/001/251/837/datas/original.png)

We explore the loss log of 4 cycles:

![Alt text](https://challengepost-s3-challengepost.netdna-ssl.com/photos/production/software_photos/001/251/818/datas/original.png)

We predict on the testing set and print out the confusion matrix:
![Alt text](https://challengepost-s3-challengepost.netdna-ssl.com/photos/production/software_photos/001/251/817/datas/original.png)

-Eosinophil: Precision = 0.84, Recall = 0.90

-Lymphocyte: Precision = 1 , Recall = 0.99

-Monocyte: Precision = 0.73, Recall = 1

-Neutrophil: Precision = 0.91, Recall = 0.68

Overall, the model is performing quite well on most of the cells where we have precision and recall above 0.84.  However, there does seem to be some confusion (low precision rate) between neutrophils and eosinophils, also neutrophil and monocyte (low recall rate).

**App development:**
Convert fast.ai trained image classification model to iOS app via ONNX and Apple Core ML. We develop our app in iOS because it is highly secured in privacy protection, especially for a sensitive data like lab test. This proves to be the main reason why many digital health and medical devices companies choose iOS as their main developing platform. Plus, iPad is widely used by doctors and medical staff across the world. This is the UI of our app:
![Alt text](https://challengepost-s3-challengepost.netdna-ssl.com/photos/production/software_photos/001/254/673/datas/original.png)

## Challenges we ran into

**Vi & Phi:** 

> This hackathon project was a very different experience for us which challenged us throughout this project with the Fastai. This is the first time we all were working with Fastai and creating endpoints of the pre-trained Resnet34 model. Deploying the trained model to iOS app is also time-consuming and take us a lot of trials. 

**Minh**:

> One issue when developing this iOS app is to allow users to be able to select multiple images in the app. Since Swift does not provide any built-in library for that feature, we have to use external library called DKImagePickerController. It took a lot of effort to set up the library to be able to select and retrieve images correctly. We also want to visualize the result in a bar chart which Swift also does not have built-in library for that. Thankfully, we found the open source library called Macaw which helped us build impressive charts for our app.

**Erick:**

> Working with fastai proved to be just that, fast. However, coming from a PyTorch background, understanding the distinct workflow and unique object properties of fastai was challenging, especially when the methodologies of PyTorch and fastai conflicted. Despite this, we were thankful for the rich documentation of fastai that is provided online. Aside from this, converting our PyTorch model to a Core ML model was somewhat of a process due to it being my first time experience with such tasks


## Accomplishments that we're proud of

We manage to finish the project in such a limited time of 24 hours in our free time from school and work. We still keep striving to submit on time while learning and developing at the same time. We are really satisfied and proud of our final product for the hackathon.

## What we learned

Through this project, we learn to implement a complicated image-recognition deep learning models from Fastai. We also learn the process of developing a mini data science project from finding dataset to training the deep learning model and finally deploy & integrate it into iOS-app. This project can’t be done without the efforts and collaboration from a team with such diverse backgrounds in technical skills.

## What's next for HemoCount - An AI-based White Blood Cell Count Platform 

In the next 2 months, our plan is:

-We will raise fund to invest more into the R&D process.

-We will partner with research lab to collect more dataset and find hospitals to test our solution.

-Regarding our R&D, we plan on improving the performance of the platform, preferably by reading more scientific literature on state-of-art deep learning models implemented for hematology.

-Eventually, we will expand our classes to include red blood cells and platelets. so that this platform can be widely used by the lab technologists for general blood test. Our end goal is to make this tool a scalable that can be used in all the laboratories across the globe, even in the rural area with limited access to the internet like those in Southeast Asia or Africa.

##Reference:
Souza, T. (2020, April 27). COVID-19 Machine Learning-Based Rapid Diagnosis From Common Laboratory Tests. Retrieved October 17, 2020, from https://towardsdatascience.com/covid-19-machine-learning-based-rapid-diagnosis-from-common-laboratory-tests-afafa9178372

https://www.kaggle.com/paultimothymooney/blood-cells
