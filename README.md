## scoreReel

This is evolving into multiple applications in one after starting out with just sports scores.

### The "score" part

Being a sports fan with Rokus at home who doesn't always have a smart phone handy to check scores, I got the itch implement my own "channel" to provide that. 

### The "reel" part

I want an to be able to track watch lists for movies and TV show on the Roku.

Someone who wants to deploy their own version of this, create a `secrets.json` file in the `/source` directory:

```
{
    "tmdb_api_key": "<TMDB api key>",
    "tmdb_user_id": "<TMDB user id>"
}
```

Need to create TMDB develop account for those values.

---

I had wanted two separate apps but Roku only allow on application to occupy the "dev" slot, so I combined them into one. This is for personal use and I don't need to publish them publicly 

Even though Roku and Brightscript are a niche technologies, it is interesting experience to develop for such a platform. 



