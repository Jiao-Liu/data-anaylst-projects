

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import NoSuchElementException
import pandas as pd

# Set up the WebDriver
wb = webdriver.Chrome()

# Open the IMDB Top 250 movies page
wb.get('https://www.imdb.com/chart/top/')

# Initialize the data dictionary
dict ={
    
    "Ranking":[],
    "Title":[],
    "Year":[],
    "Duration":[],
    "Genre":[],
    "Point":[],
    "Vote_Count":[]
    
    
}

    
# Wait for the page elements to load
wait = WebDriverWait(wb, 10)

# Get the <ul> element that contains the movie list
movie_list = wait.until(EC.presence_of_element_located((By.XPATH, '//*[@id="__next"]/main/div/div[3]/section/div/div[2]/div/ul')))

# Get all the <li> elements representing each movie
movies = movie_list.find_elements(By.XPATH, './/li')
 
# Loop through all movie items and extract the data
for index, movie in enumerate(movies):
    try:
        # Extract the movie title
        title = movie.find_element(By.XPATH, './/div[2]/div/div/div[1]/a/h3').text
        ranking = index + 1
        year = movie.find_element(By.XPATH, './/div[2]/div/div/div[2]/span[1]').text
        duration = movie.find_element(By.XPATH, './/div[2]/div/div/div[2]/span[2]').text
         # Try to extract the genre; if it doesn’t exist, set a default value
        try:
            genre = movie.find_element(By.XPATH, './/div[2]/div/div/div[2]/span[3]').text
        except NoSuchElementException:
            genre = 'Not Rated'
      
        point = movie.find_element(By.CSS_SELECTOR, '.ipc-rating-star--rating').text
        vote_count = movie.find_element(By.CSS_SELECTOR, '.ipc-rating-star--voteCount').text
        
        #print(title)
        #print(ranking)
        
        dict["Ranking"].append(ranking)  # 排名从1开始
        dict["Title"].append(title)
        dict["Year"].append(year)
        dict["Duration"].append(duration)
        dict["Genre"].append(genre)
        dict["Point"].append(point)
        dict["Vote_Count"].append(vote_count)
        
        
        
    except NoSuchElementException as e:
        print(f"Error extracting data for movie {index + 1}: {e}")
        title = year = duration = genre = point = vote_count = 'N/A'
        ranking = index + 1  
 
# Create a DataFrame       
df = pd.DataFrame(dict)

# save to local 
df.to_csv(r'/Users/jiaoliu/Documents/数分学习/alex/Python/imdb_selenium_scraped.csv',index=False)

# Close the browser
wb.quit()


       