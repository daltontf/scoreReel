## scoreReel+

This is evolving into multiple applications in one after starting out with just sports scores. The "+" is because there is US weather component now.

### The "score" part

Being a sports fan with Rokus at home who doesn't always have a smart phone handy to check scores, I got the itch implement my own "channel" to provide that. 

### The "standings" part

After using the score feature for a while, I started to want to be able to check standings of various leagues. 

### The "reel" part

I want an to be able to track watch lists for movies and TV show on the Roku.

Someone who wants to deploy their own version of this, add the following to `secrets.json` file in the `/source` directory:

```
"tmdb": {
    "api_key": "<TMDB api key>",
    "user_id": "<TMDB user id>"
}
```

Need to create TMDB develop account for those values.

### The "weather" part

Add the following to `secrets.json` file in the `/source` directory: 

```
"weather": {
     "gridpoint_url": <gridpoint URL from weather.gov>
}
```

One way to determine this is the open `https://api.weather.gov/points/{latitude},{longitude}` where latitude and longitude are replaced with the coordinates of the desired location. The returned JSON will have a `properties` value with `forecastGridData` value with the URL.

---

I had wanted two separate apps but Roku only allow on application to occupy the "dev" slot, so I combined them into one. This is for personal use and I don't need to publish them publicly 

Even though Roku and Brightscript are a niche technologies, it is interesting experience to develop for such a platform. 



