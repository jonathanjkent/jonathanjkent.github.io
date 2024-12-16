+++
image = "img/portfolio/boston.png"
showonlyimage = false
date = "2016-11-05T19:44:32+05:30"
title = "American Urban Fabric"
draft = false
weight = 2
+++

I am working to bring "Continuous Urban Fabric" data to the American context, starting with Massachusetts.
<!--more-->

My research has show that residents of cities with more continuous urban fabric are more likely to have [positive attitudes towards immigrants](https://www.sciencedirect.com/science/article/pii/S0264275121003930) and less likely to [support the far right](https://www.sciencedirect.com/science/article/pii/S1877916623000528). This work was inspired by the work of Jane Jacobs, who found that compact, traditional urban designs wrought all kinds of benefits. In Europe, datasets like the Copernicus Urban Atlas include a land cover type called "urban fabric" that is any area with at least some residences. The type is then disaggregated into "continuous" and "discontinuous" subtypes depending on how much of the urban fabric is covered by artificial surfaces. At first glance, this data might not have much relevance for social science. But on a closer look, the continuous/discontinuous dichotomy has a lot in common with Jacobs dichotomy between traditional and modern urban designs. She memorably said that one thing the various modern design styles had in common was their love of "grass, grass, grass." The urban renewal she railed against replaced densely packed neighborhoods (artificially covered, nearly in full) with single family homes or residential skyscrapers---inevitably surrounded by grass.

I believe continuous urban fabric may be an indicator of other social goods, but, alas, it isn't available in American geographic datasets. Thankfully, we can replicate the distinction by combining land cover and land use data. MassGIS helpfully provides [synergized shapefiles](https://www.mass.gov/info-details/massgis-data-2016-land-coverland-use). To compute an index of urban fabric continuity, I first identify how much land in a Census blockgroup (or tract, or block) is residential or mixed use. Then, of that land, I calculate the percentage that is impermeable.

The result looks like this, for Boston: https://kentresearch.github.io/boston_urban_fabric.html

Stay tuned for more from this project, including replications of my previous findings for US contexts.

