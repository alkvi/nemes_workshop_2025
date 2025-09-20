# NEMES 2025 fNIRS workshop

Some basic analysis of an open dataset, in:

- MNE-NIRS
- NIRS Brain AnalyzIR toolbox
- HomER3

# Downloading data

The prepared pipelines use an open dataset published on the [openfnirs](https://openfnirs.org/data/) website. In particular, we will use the `Luke2021tap` dataset prepared by Rob Luke, described [here](https://github.com/rob-luke/BIDS-NIRS-Tapping):

> This experiment examines how the motor cortex is activated during a finger tapping task. Participants are asked to either tap their left thumb to fingers, tap their right thumb to fingers, or nothing (control). Tapping lasts for 5 seconds as is prompted by an auditory cue. Sensors are placed over the motor cortex as described in the montage section in the link below, short channels are attached to the scalp too.

This dataset is prepared according to the [BIDS](https://bids-specification.readthedocs.io/en/stable/modality-specific-files/near-infrared-spectroscopy.html) specification and uses [SNIRF](https://github.com/fNIRS/snirf) files to store data.

Download the dataset and place it in the 'data' folder, and unzip it. You should now have a folder called  `rob-luke-BIDS-NIRS-Tapping-e262df8` in your data folder.

Or run:

~~~
cd data
curl -L -o BIDS-NIRS-Tapping-v0.1.0.zip https://zenodo.org/records/6575155/files/rob-luke/BIDS-NIRS-Tapping-v0.1.0.zip
unzip BIDS-NIRS-Tapping-v0.1.0.zip
cd ..
~~~

# MNE-NIRS

~~~
cd MNE_pipeline
py -m venv mne_workshop
~~~

If on Windows:

~~~
.\mne_workshop\Scripts\activate.bat
~~~

If on Mac or Linux:

~~~
source mne_workshop/bin/activate
~~~

Then:

~~~
pip install -r requirements.txt
jupyter notebook
~~~

# AnalyzIR / nirs-toolbox

# HomER3

