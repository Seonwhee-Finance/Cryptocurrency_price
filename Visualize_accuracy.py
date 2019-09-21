# Libraries
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from math import pi

def Spider_plot(df, training = {'Train':0, 'Test':1}):
    # number of variable
    categories=list(df)
    N = len(categories)    
    
    # Initialise the spider plot
    ax = plt.subplot(111, polar=True)
    # What will be the angle of each axis in the plot? (we divide the plot / number of variable)
    angles = [n / float(N) * 2 * pi for n in range(N+1)]
    angles += angles[:1]    
    # Draw one axe per variable + add labels labels yet
    plt.title("Classification Accuracy", size=20)
    plt.xticks(angles[:-1], categories, color='black', size=14)
    
    # Draw ylabels
    ax.set_rlabel_position(0)
    plt.yticks(list(np.arange(0.1, 1.0, 0.2)), ["0.2","0.4","0.6","0.8","1.0"], color="grey", size=10)
    plt.ylim(0,1)
    colorPal = {'Train':'b', 'Test':'g'}
    
    for v in training:
        values=df.loc[training[v]].values.flatten().tolist()
        values += values[:-1]  
        
        Drawing_plot(ax, angles, values, colorPal[v], v)
    
def Drawing_plot(ax, angles, values, color, lbl):
    
    # Plot data
    ax.plot(angles, values, linewidth=1, linestyle='solid', label=lbl)
    
    # Fill area
    ax.fill(angles, values, color, alpha=0.1)
    ax.legend()
    
if __name__=="__main__":
    # Set data
    df = pd.DataFrame({'Rise': [0.38, 0.4],'Fall': [0.29, 0.6],'Steady': [0.8, 0.7]})
    Spider_plot(df)