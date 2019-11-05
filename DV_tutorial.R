# Intro to ggplot2
# 5.11.19
# Rick Scavetta
# Data Viz workshop in Jena MPI BGC

# Clear workspace
rm(list = ls())

# load packages
library(ggplot2)
library(RColorBrewer)
library(Hmisc)

# Using colours
# Display colour palettes:
display.brewer.all(type = "seq")
display.brewer.pal(9, "Blues")

# Get the color code:
brewer.pal(9, "Blues")
# Get the 4th, 6th and 8th colour:
myBlues <- brewer.pal(9, "Blues")[c(4,6,8)]

# view hex colours:
munsell::plot_hex(myBlues)

# Intro to ggplot2:
# 3 essential layers:
# 1 - Data, here a built-in dataset
mtcars
str(mtcars)

# Convert cyl and am to proper categorical variables:
mtcars$cyl <- factor(mtcars$cyl)
mtcars$am <- factor(mtcars$am)

# 2 - Aesthetics: MAP a variable onto a visible scale
# using the aes()
# 3 - Geometry: How will the plot look

# Histogram
ggplot(mtcars, aes(x = mpg)) +
  geom_histogram(binwidth = 1, center = 0.5, fill = "red")

# Scatter plot
ggplot(mtcars, aes(x = wt, y = mpg, colour = cyl)) +
  geom_point(shape = 16, alpha = 0.65)

# Deal with overpotting:
# alpha: 0-1
# shape: 
# 1 - circle outline only
# 16 - circle without oultline
# 19 - default, circle with outline
# 21 - circle with a different colour outline
# jitter: BUT... not here

# Attributes: SETTING a value for a scale

# Bar plot
table(mtcars$am, mtcars$cyl)

# Default position = "stack"
ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar()

# position = "dodge"
ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar(position = "dodge")

# position = "fill" - gives proportions
ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar(position = "fill")


# Changing scales
# aesthetics == scales == axes
# categorical == qualitative == factor == discrete

ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar(position = "dodge") +
  scale_y_continuous(limits = c(0,12), 
                     breaks = seq(0,12,4),
                     expand = c(0,0)) +
  scale_fill_brewer(palette = "Set1") +
  labs(x = "Cylinders", 
       y = "Count", 
       fill = "Transmission\ntype")

p <- ggplot(mtcars, aes(x = wt, y = mpg, colour = cyl)) +
  geom_point(shape = 16, alpha = 0.75) +
  scale_colour_manual("Cylinders", values = myBlues) +
  scale_x_continuous("Weight (1000 lbs)",
                     limits = c(1,6),
                     expand = c(0,0)) +
  scale_y_continuous("Miles per (US) Gallon", 
                     limits = c(10, 35),
                     expand = c(0,0))

# The Stats layer:
# Add (smoothing) models
# stat smooth inherits groups according to color
p +
  stat_smooth(method = "lm", se = FALSE)

# to get one model:
# specify a dummy group aesthetic 
p +
  stat_smooth(aes(group = 1), method = "lm", se = FALSE)

# Descriptive stats
# wt described by cyl, for each am type

# base layer:
q <- ggplot(mtcars, aes(x = cyl, y = wt, color = am))

# Define positions:
posn_d <- position_dodge(0.2)
posn_j <- position_jitter(0.2)
posn_jd <- position_jitterdodge(0.2, dodge.width = 0.2)

# Add points only:
q +
  geom_point(position = posn_jd, alpha = 0.6)
  
# Mean & SD:
smean.sdl(1:100, mult = 1) # From Hmisc
mean_sdl(1:100, mult = 1) # The ggplot2 version

q +
  stat_summary(fun.data = mean_sdl, 
               fun.args = list(mult = 1),
               position = posn_d)

# Mean & 95%CI:
q +
  stat_summary(fun.data = mean_cl_normal,
               position = posn_d)

mean_cl_normal(1:100) # The ggplot2 version

# The Coordinates layer:
# scale_*_*() FILTER the data
q +
  stat_summary(fun.data = mean_sdl, 
               fun.args = list(mult = 1),
               position = posn_d) +
  scale_y_continuous(limits = c(1,5), 
                     expand = c(0,0))
  
# coord_*() ZOOMS IN on the data
q +
  stat_summary(fun.data = mean_sdl, 
               fun.args = list(mult = 1),
               position = posn_d) +
  coord_cartesian(ylim = c(1,5))

# The Facets layers:
# Another tool for dealing with categorical variables
# Don't need to necessarily have factors

# By rows:
p +
  facet_grid(rows = vars(gear))

# By columns:
p +
  facet_grid(cols = vars(am))


# By both rows and columns:
p +
  facet_grid(rows = vars(gear), cols = vars(am))

# using formula notation:
p +
  facet_grid(gear ~ am)
p +
  facet_grid(. ~ am)
p +
  facet_grid(gear ~ .)

# The Themes layer: Non-data Ink
p +
  theme_classic(base_size = 14) +
  theme(rect = element_blank(),
        axis.ticks = element_line(color = "black"),
        axis.text = element_text(color = "black"),
        legend.position = c(0.8, 0.8))

# Saving plots:
# Vectors - svg, eps, ps, il, pdf
# instructions, no resolution
# Rasters - jpg, tif, png, gif, bmp, img, raw
# pixels, with resolution

p_size <- 3 
base_size <- 14
ggsave("myPlot_small_14.png", height = p_size, width = p_size, units = "in")
ggsave("myPlot_small_14.pdf", height = p_size, width = p_size, units = "in")


png("myPlot_dev.png")
p +
  theme_classic() +
  theme(rect = element_blank(),
        axis.ticks = element_line(color = "black"),
        axis.text = element_text(color = "black"),
        legend.position = c(0.8, 0.8))
dev.off()




  
