## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE,
                      comment  = "#>")

## ----setup--------------------------------------------------------------------
library(cancerR)

# Make example data

data <- data.frame(
  icd_o3_histology = c("8522", "9490", "9070"),
  # Different formats of site codes commonly found in cancer registries
  icd_o3_site = c("C50.1", "C701", "620"),
  icd_o3_behaviour = c("3", "3", "3")
)

head(data)


## -----------------------------------------------------------------------------

# Convert site codes
data$site_conv <- site_convert(data$icd_o3_site, validate = FALSE)

head(data)


## -----------------------------------------------------------------------------

# Valid site codes
site_convert("C34.1", validate = TRUE)

# Invalid site codes
site_convert("C99.9", validate = TRUE) # Should return NA and an warning message
site_convert("C99.9", validate = FALSE) # Should return 999


## -----------------------------------------------------------------------------

# Classify AYA cancers using Barr 2020 classification

# Classify at level 1 (most general)
data$dx_lvl_1 <- aya_class(data$icd_o3_histology, data$icd_o3_site, data$icd_o3_behaviour, depth = 1)

# Add more granular classifications
data$dx_lvl_2 <- aya_class(
  histology = data$icd_o3_histology, 
  site = data$site_conv, 
  behaviour = data$icd_o3_behaviour, 
  depth = 2
)

# Add even more granular classifications (level 3) using SEER 2020 revision classification
data$dx_lvl_3 <- aya_class(
  histology = data$icd_o3_histology, 
  site = site_convert(data$icd_o3_site), # Convert site codes using site_convert()
  behaviour = data$icd_o3_behaviour,
  method = "SEER v2020",
  depth = 3
)

# View created columns
print(data[, c("dx_lvl_1", "dx_lvl_2", "dx_lvl_3")])


## -----------------------------------------------------------------------------

# Make example data

data_kid <- data.frame(
  histology = c("8522", "9490", "9070"),
  site = c("C50.1", "C701", "620"),
  behaviour = c("3", "3", "3")
)

# Classify childhood cancers using ICCC-3 classification
data_kid$dx_lvl_1 <- kid_class(data_kid$histology, data_kid$site, depth = 1) # ICCC-3
data_kid$dx_lvl_1.seer <- kid_class(data_kid$histology, data_kid$site, method = "who-iccc3", depth = 1) # WHO-SEER recode

# Add SEER grouping column
data_kid$seer_grp <- kid_class(data_kid$histology, data_kid$site, depth = 99)

# View results
head(data_kid)


