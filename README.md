
clean up the files from other storms:
```
git checkout -b Harvey-al092017
rm -rf build/status
rm -rf .remake
```
list all .ind files:
```
find . -name "*.ind" -type f
```
delete all .ind files:
```
find . -name "*.ind" -type f  -delete
```

delete all .png GIF frames:
```
find 6_visualize/tmp/ -name "*.png" -type f  -delete
```


create new storm folder in https://drive.google.com/drive/u/0/folders/0B8skwPIYgrA_aG1JWUNDZXNmV0E named to match the branch

update lib.yml with the folder key
run make on the config:
```r
scmake(remake_file = 'lib.yml')
```

make the gif_tasks remake_file: 
```r
scmake('6_storm_gif_tasks.yml')
```

Pick any test frame and build that:
```r
scmake('6_visualize/tmp/gif_TEST_frame_a_20170825_11.png', '6_storm_gif_tasks.yml')
```

iterate on style and layout in `viz_config.yml` and potentially in the `prep_fun` plotting functions to get the desired result
