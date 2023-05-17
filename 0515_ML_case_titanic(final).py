# Load libraries
# import sys
# import scipy
# import numpy
# import matplotlib
# import pandas
# import sklearn
# from pandas import read_csv

# Load libraries
import pandas as pd
from pandas.plotting import scatter_matrix
from matplotlib import pyplot
from sklearn.model_selection import train_test_split
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import StratifiedKFold
from sklearn.metrics import classification_report
from sklearn.metrics import confusion_matrix
from sklearn.metrics import accuracy_score
from sklearn.linear_model import LogisticRegression
from sklearn.tree import DecisionTreeClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.naive_bayes import GaussianNB
from sklearn.svm import SVC
from sklearn.model_selection import KFold
from sklearn.preprocessing import StandardScaler

dirname=".\Cases\database\\"
dataset=pd.read_excel(dirname+"cata.xlsx")

dataset=dataset.drop(['name','sibsp', 'parch', 'ticket', 'fare', 
                      'cabin', 'embarked', 'boat', 'body', 'home.dest'],axis=1)
dataset=dataset[['survived','pclass', 'sex', 'age']]

# shape, head, descriptions of the dataset and dropna
print(dataset.shape)
print(dataset.head())
print(dataset.describe())
dataset=dataset.dropna(axis=0)

# change Y data type for the categorical ("yes"=survived, "no"=not survived) 
# change X data to numerical ("female"=0, "male"=1)
# set up data types
dataset.survived.replace(to_replace=[0,1],value=["no","yes"], inplace=True)
# dataset.loc[dataset['survived']==0,"survived"]="no"
# dataset.loc[dataset['survived']==1,"survived"]="yes"
dataset.sex.replace(to_replace=["female","male"],value=[0,1], inplace=True)
# dataset.loc[dataset['sex']=="female","sex"]=0
# dataset.loc[dataset['sex']=="male","sex"]=1
dataset = dataset.astype({'survived':'category','pclass':'int','sex':'int','age':'float'})
print(dataset.info())

# EDA (exploratory data analysis) - scatter plot matrix
# scatter_matrix(dataset)
# pyplot.show()

# split-out validation dataset
array = dataset.values
X = array[:,1:]
y = array[:,0]

# standardize the data (e.g. the age scale is times higher vs the others)
object=StandardScaler()
X=object.fit_transform(X)

# set up the train & test split
X_train, X_validation, Y_train, Y_validation = train_test_split(X, y, test_size=0.20, random_state=1)

# the goal is to check different models for prediction (linear and non-linear ones)
# and choose the most accurate one. The list of models is given below:
# 1. Spot Check Algorithms
# 2. Logistic Regression (LR)
# 3. Linear Discriminant Analysis (LDA)
# 4. K-Nearest Neighbors (KNN)
# 5. Classification and Regression Trees (CART)
# 6. Gaussian Naive Bayes (NB)
# 7. Support Vector Machines (SVM)
models = []
models.append(('LR', LogisticRegression(solver='liblinear', multi_class='ovr')))
models.append(('LDA', LinearDiscriminantAnalysis()))
models.append(('KNN', KNeighborsClassifier()))
models.append(('CART', DecisionTreeClassifier()))
models.append(('NB', GaussianNB()))
models.append(('SVM', SVC(gamma='auto')))

# evaluate each model in turn and show the final results
# the Support Vector Machines (SVM) show the best results (correlation and std error)
results = []
names = []
for name, model in models:
    kfold = StratifiedKFold(n_splits=10, random_state=1, shuffle=True)
    cv_results = cross_val_score(model, X_train, Y_train, cv=kfold, scoring='accuracy')
    results.append(cv_results)
    names.append(name)
    print('%s: %.2f (%.2f)' % (name, cv_results.mean(), cv_results.std()))

# Compare different Algorithms
# the Support Vector Machines (SVM) show the best results 
# (correlation - 0.79 and std error - 0.03)
pyplot.boxplot(results, labels=names)
pyplot.title('Algorithm Comparison')
pyplot.show()

# Make predictions on validation dataset by using SVM model
model = SVC(gamma='auto')
model.fit(X_train, Y_train)
predictions = model.predict(X_validation)

# Evaluate predictions: high accuracy score (0.83) = TP+TN
# high f1-score (precision, recall)
# confusion matrix: FPR/T1 error (FP) - 17 (8%), FNR/T2 error (FN) - 19 (9%)
print("______________________________________________")
print("accuracy_score")
print('%.2f' % accuracy_score(Y_validation, predictions))
print("______________________________________________")
print("confusion_matrix")
print(confusion_matrix(Y_validation, predictions))
print("______________________________________________")
print("classification_report")
print(classification_report(Y_validation, predictions))

# Evaluate all the X data by using SVM model, high accuracy score (0.81)
predictions2=model.predict(X)
print("______________________________________________")
print("accuracy_score for all X data")
print(round(sum(y==predictions2)/len(y),2))

print("________________________________________________")

# now let's quantify the impact of factors (pclacc,sex,age) on survival
# Linear Regression Feature Importance (the data was standardized in the very beginning)
# the highest impact on survival makes sex (-1.17)
# followed by pclass (-0.83) and finally age (-0.47)

model_feature = LogisticRegression(solver='liblinear', multi_class='ovr')
model_feature.fit(X_train, Y_train)
importance=model_feature.coef_
cols=list(dataset.columns[1:])
for i in range(len(cols)):
    print('%s: %.2f' % (cols[i],importance[0,i]))
