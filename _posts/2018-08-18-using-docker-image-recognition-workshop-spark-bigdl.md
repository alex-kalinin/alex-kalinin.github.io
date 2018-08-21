---
title: 1-day Hands-on Image Recognition workshop using Apache Spark and BigDL
featured: true
---

### Links

1. **Slides**: 
    1. **Part 1 -- Image Recogntion**: [https://www.slideshare.net/AlexKalinin2/intro-to-image-recognition-with-deep-learning-using-apache-spark-and-bigdl-81058094](https://www.slideshare.net/AlexKalinin2/intro-to-image-recognition-with-deep-learning-using-apache-spark-and-bigdl-81058094)
    1. **Part 2 -- Transfer Learning**: [https://www.slideshare.net/AlexKalinin2/transfer-learning-with-apache-spark-and-big-dl](https://www.slideshare.net/AlexKalinin2/transfer-learning-with-apache-spark-and-big-dl)
2. **Notebooks**: [https://github.com/alex-kalinin/lenet-bigdl](https://github.com/alex-kalinin/lenet-bigdl)
3. **Meetup page**: [https://www.meetup.com/datariders/events/252497163/](https://www.meetup.com/datariders/events/252497163/)

### Instructions


The instructions below show how to download the docker image and run the notebooks on your laptop or cloud instance for the [1-day Hands-on Image Recognition workshop using Apache Spark and BigDL](https://www.meetup.com/datariders/events/252497163/).

First, you need to have the docker service installed. Once it's done, download the image with the command:


```bash
	docker pull kalininalex/bigdl-workshop
```

After the download completes, start the container:

```bash
docker run  -p 8888:8888 -p 6006:6006 -it kalininalex/bigdl-workshop 
```

You should see the output:

```
[I 03:05:26.954 NotebookApp] Serving notebooks from local directory: /usr/src/app
[I 03:05:26.954 NotebookApp] 0 active kernels
[I 03:05:26.955 NotebookApp] The Jupyter Notebook is running at:
[I 03:05:26.955 NotebookApp] http://[all ip addresses on your system]:8888/
[I 03:05:26.955 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
TensorBoard 1.10.0 at http://a2894c73f662:6006 (Press CTRL+C to quit)
```

You can now connect to Jupyter via the URL:
```
http://<address>:8888/
```

The `<address>` is either `127.0.0.1`, if you do it locally, or the IP address of your cloud instance. 

Once you connect, create an empty notebook. You will use it to clone the repository with all the necessary notebooks and files. In the new notebook, type in the following code:

```bash
!git clone https://github.com/alex-kalinin/lenet-bigdl
```

Don't miss the leading exclamation mark (!). It tells Jupyter that this is a shell command rather than the Python code. Once it completes, go back to the Home page of the Jupyter UI. There you will see a new directory, **`lenet-bigdl`**. Click on it, then **`Workshop-1`**, and you will see the notebooks:

```
...
1. MNIST with LeNet-BigDL.ipynb
2. Transfer - Flowers - Analytics Zoo.ipynb
```

Open each notebook and follow the instructions. If you have any questions, feel free to contact me via LinkedIn or Github. 
