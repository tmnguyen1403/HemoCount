## Demo Hemocount

![Demo](./Gif/demo3.gif)

## Inspiration
The sudden and rapid growth of COVID-19 cases is overwhelming health systems globally. Fast, accurate and early detection of SARS-CoV-2 is of vital importance to control the spread of the virus. However, traditional SARS-CoV-2 detection based on RT-PCR assays can be costly, long-drawn-out and widely unavailable making testing every case an impractical effort. From an analysis on 5644 patients (with 558 tested positive for SARS-CoV-2) from the Hospital Israelita Albert Einstein in São Paulo, Brazil, the result shows that  that patients admitted with COVID-19 symptoms who tested negative for Rhinovirus Enterovirus, Influenza B and Inf.A.H1N1.2009 and presented low levels of Leukocytes and Platelets were more likely to test positive for SARS-CoV-2. (Souza, 2020) In this work, we propose a deep learning-based approach for the rapid detection of COVID-19 cases using commonly available laboratory data of thin blood smears to count the number of Leukocytes and Platelets. Due to time constraint for this Datathon, we are only able to finish the deep learning model to count Leukocytes or white blood cells (WBC). 

## What it does
In the manual approach, a sample of blood is placed under a microscope and a pathologist manually counts the number of cells in each frame. The total count is then extrapolated by assuming that the distribution is uniform across the entire blood sample and multiplying up.

In our approach using deep learning, the HemoCount platform focuses on identifying the white blood cell sample and classify them in 4 classes: Lymphocyte, Monocyte, Neutrophil and count their presence in the blood smear. 
An advantage of the deep learning approach is that we will be exploring through the rest of this blog post is a potentially promising advancement over such techniques due to a few reasons:
It requires far cheaper equipment. Hence it will reduce the cost.
It provides rapid result on a large scale of blood cell counting, almost instantly.
We can see a potential time-saving effect of our AI-based platform vs the manual process:
![Alt text](https://challengepost-s3-challengepost.netdna-ssl.com/photos/production/software_photos/001/251/711/datas/original.png)


## How we built it
**Dataset:**

This dataset contains 12,500 augmented images of various types of white blood cells (JPEG) with metadata in CSV form. That includes 3,000 images divided into 4 different white blood cell types (classes). We split train-test on 80-20 ratio for each of the classes. 

**Training process:**

Source: https://www.kaggle.com/paultimothymooney/blood-cells
![Alt text](https://challengepost-s3-challengepost.netdna-ssl.com/photos/production/software_photos/001/251/824/datas/original.png)

After loading the image, we preprocess the data using image augmentation:
![Alt text](https://challengepost-s3-challengepost.netdna-ssl.com/photos/production/software_photos/001/251/823/datas/original.png)

For this project, we use pretrained Resnet34 for transfer learning and retraining this on the last layer.
![Alt text](https://challengepost-s3-challengepost.netdna-ssl.com/photos/production/software_photos/001/251/821/datas/original.png)

We use learning rate finder from Fastai to explore the best learning rate for our model.
![Alt text](https://challengepost-s3-challengepost.netdna-ssl.com/photos/production/software_photos/001/251/837/datas/original.png)

We explore the loss log of 4 cycles and they seem good:

![Alt text](https://challengepost-s3-challengepost.netdna-ssl.com/photos/production/software_photos/001/251/818/datas/original.png)

We predict on the testing set and print out the confusion matrix:
![Alt text](https://challengepost-s3-challengepost.netdna-ssl.com/photos/production/software_photos/001/251/817/datas/original.png)

-Eosinophil: Precision = 0.84, Recall = 0.90

-Lymphocyte: Precision = 1 , Recall = 0.99

-Monocyte: Precision = 0.73, Recall = 1

-Neutrophil: Precision = 0.91, Recall = 0.68

Overall, the model is performing quite well on most of the cells where we have precision and recall above 0.84.  However, there does seem to be some confusion (low precision rate) between neutrophils and eosinophils, also neutrophil and monocyte (low recall rate).

**App development:**
Convert fast.ai trained image classification model to iOS app via ONNX and Apple Core ML

## Challenges we ran into
This hackathon project was a very different experience for us which challenged us throughout this project with the Fastai. This is the first time we all were working with Fastai and creating endpoints of the pre-trained Resnet34 model. Deploying the trained model to iOS app is also time-consuming and take us a lot of trials. 

One issue when developing this iOS app is to allow users to be able to select multiple images in the app. Since Swift does not provide any built-in library for that feature, we have to use external library called DKImagePickerController. It took a lot of effort to set up the library to be able to select and retrieve images correctly.
We also want to visualize the result in a bar chart which Swift also does not have built-in library for that. Thankfully, we found the open source library called Macaw which helped us build impressive charts for our app. 
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