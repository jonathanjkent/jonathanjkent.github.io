+++
image = "img/portfolio/training-viz.png"
showonlyimage = true
draft = false
date = "2016-11-05T19:53:42+05:30"
title = "Marathon Training Data Project"
weight = 7
plotly = true
+++

There are number of [excellent apps](https://www.strava.com/athletes/50949747) and [websites](https://runalyze.com) that take running data from GPS watches and generate race time predictions, visualizations, and even training recommendations. Honestly, checking these sites can become a bit of an obsession. Wise coaches insist that consistency is what matters, but marathoners are perfectionists, addicted to improvement.
<!--more-->

It's easy to go too hard in a workout in hopes of seeing positive reinforcement when your watch data syncs. Marathoners need an app that incentivizes steady progress instead of pushing the pace. I am working on something like that, release date TBD. Here are a few test visualizations that remind users of past gaps in training (due to overstress injuries, inevitably) and reward plugging away.

{{< plotly json="/json/block_dist.json" height="400px" >}}

There are quite a few ways to calculate [Training Impulse](https://fellrnr.com/wiki/TRIMP). Here, I use exponential heart rate scaling based on lap-wise Strava data, and plot the cumulative values across training blocks. Using training impulse is a nice way to include cross training data without making assumptions about the running equivalent of, for example, one hour of cycling.

{{< plotly json="/json/training_impulse.json" height="250px" >}}

