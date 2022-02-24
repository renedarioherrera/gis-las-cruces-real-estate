# gis project to exclude the areas around major roads and highways
# and industrial areas or other areas of pollution from a real estate search
# rené dario herrera
# 20 February 2022

# packages
library(here)
library(tidyverse)
library(janitor)
library(tidycensus)
library(tigris)
library(sf)

# options
options(tigris_use_cache = TRUE)

# read geographic boundary of county 
county_boundary <- counties(
  state = "NM"
) %>%
  clean_names()

county_boundary_dona_ana <- county_boundary %>%
  filter(name == "Doña Ana")

st_crs(county_boundary_dona_ana)

st_write(
  obj = county_boundary_dona_ana,
  dsn = "../grass-gis-database-directory/county_boundary_dona_ana.geojson",
  driver = "GeoJSON"
)

# read road data
roads_nm <- primary_secondary_roads(state = "NM") %>%
  clean_names() 

st_crs(roads_nm)

st_write(
  obj = roads_nm,
  dsn = "../grass-gis-database-directory/roads_nm.geojson",
  driver = "GeoJSON"
)

roads_nm %>%
  distinct(rttyp)

# roads_nm %>%
#   filter(
#     rttyp %in% c("I", "U", "S"))

# show only county roads 
roads_dona_ana <- st_join(
  x = county_boundary_dona_ana,
  y = roads_nm
)

ggplot() +
  geom_sf(data = county_boundary_dona_ana)
  geom_sf(data = roads_dona_ana, color = "blue")
