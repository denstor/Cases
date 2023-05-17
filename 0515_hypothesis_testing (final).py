#the given below case shows the logics of the test of the hypothesis

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

dirname=".\Cases\database\\"
df=pd.read_excel(dirname+"cata.xlsx")

# print(df.shape)
# print(df.columns)
# print(df.describe())
# print(df.head())

df=df.drop(['name','sibsp', 'parch', 'ticket', 
       'fare', 'cabin', 'embarked', 'boat', 'body', 'home.dest'],axis=1)


df=df.dropna(axis=0)
df = df.astype({'sex':'category', 'survived':'int','pclass':'int','age':'float'})
print(df.describe())
print(df.info())

print("_____________________________________________________________")
#the more women and children survived
age=pd.cut(df["age"],[0,18,30,40,80])
print(df.pivot_table("survived",["sex",age],"pclass"))

print("_____________________________________________________________")
#the data shows clear evidence of higher chances of survival for the passengers of cl1
#although the two groups of survivors: Female&Class1 and Female&Class2 have negligible difference (96% vs 89%)
#the question I'm going to investigate further is whether this difference is statistically significant
print(df.pivot_table("survived",index="sex",columns="pclass",margins=True))

print("_____________________________________________________________")

#H1 hypothesis - there is a difference in chances to survive between cl1 & cl2
#H0 - there is no difference between these two groups
#to prove H0 I'm going use permutation samples of the empirical dataset

#the function to generate many sets of simulated data assuming H0 is true
def draw_perm_reps(data1,data2,func,size=1):
    perm_replicates=np.empty(size)
    for i in range(size):
        perm_sample1,perm_sample2=permutation_sample(data1,data2)
        perm_replicates[i]=func(perm_sample1,perm_sample2)
    return perm_replicates

#the function to calculcate difference of means
def diff_of_means(data1,data2):
    diff=np.mean(data1)-np.mean(data2)
    return diff

#the function to implement permutation of the sample
def permutation_sample(data1,data2):
    data=np.concatenate((data1,data2))
    permuted_data=np.random.permutation(data)
    perm_sample1=permuted_data[:len(data1)]
    perm_sample2=permuted_data[len(data1):]
    return perm_sample1,perm_sample2

#the code below splits out the two target groups
cl1=df["survived"][(df["sex"]=="female") & (df["pclass"]==1)]
# cl1=cl1.to_numpy()
cl1=cl1.values


cl2=df["survived"][(df["sex"]=="female") & (df["pclass"]==2)]
# cl2=cl2.to_numpy()
cl2=cl2.values

np.random.seed(123)
empirical_diff_means=diff_of_means(cl1,cl2)
print("empirical_diff_means - ",np.round(empirical_diff_means,2))
perm_replicates=draw_perm_reps(cl1,cl2,diff_of_means,1000)
# print("perm_replicates: ",perm_replicates)

#p-value is the fraction of the simulated data sets for which 
#the test statistic is at least as extreme as for the empirical dataset
p=np.sum(perm_replicates>=empirical_diff_means)/len(perm_replicates)
print("p-value: ",np.round(p,2))

#p=0.03 - 3% of simulated data has higher than empirical difference of means (7%)
#the results of the statitics let us decline H0 
#and therefore prove H1 - there is a difference between cl1 and cl2

#the chart showing distribution of the permutated means with probability
weights=np.ones_like(perm_replicates/len(perm_replicates))
plt.hist(perm_replicates,weights=weights)
plt.xlabel("distribution of differences of the permutated means")
plt.ylabel("probability")
plt.show()

#although the two groups of survivors: Female&Class1 and Female&Class2 have negligible difference (96% vs 89%)
#the experiment proved that the difference is statistically significant
#which means that Female&Class1 have higher chances to survive vs Female&Class2
