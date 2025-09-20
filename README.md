# NEMES 2025 fNIRS workshop

Some basic analysis of an open dataset, in:

- MNE-NIRS
- NIRS Brain AnalyzIR toolbox
- Homer3

# Downloading the repository

First download this workshop repository via Code -> Download zip or via git:

~~~
git clone https://github.com/alkvi/nemes_workshop_2025.git
~~~

# Downloading data

The prepared pipelines use an open dataset published on the [openfnirs](https://openfnirs.org/data/) website. In particular, we will use the `Luke2021tap` dataset prepared by Rob Luke, described [here](https://github.com/rob-luke/BIDS-NIRS-Tapping):

> This experiment examines how the motor cortex is activated during a finger tapping task. Participants are asked to either tap their left thumb to fingers, tap their right thumb to fingers, or nothing (control). Tapping lasts for 5 seconds as is prompted by an auditory cue. Sensors are placed over the motor cortex as described in the montage section in the link below, short channels are attached to the scalp too.

This dataset is prepared according to the [BIDS](https://bids-specification.readthedocs.io/en/stable/modality-specific-files/near-infrared-spectroscopy.html) specification and uses [SNIRF](https://github.com/fNIRS/snirf) files to store data.

Download the dataset and place it in the workshop `data` folder, and unzip it. You should now have a folder called  `rob-luke-BIDS-NIRS-Tapping-e262df8` in your `data` folder.

Or run:

~~~
cd data
curl -L -o BIDS-NIRS-Tapping-v0.1.0.zip https://zenodo.org/records/6575155/files/rob-luke/BIDS-NIRS-Tapping-v0.1.0.zip
unzip BIDS-NIRS-Tapping-v0.1.0.zip
cd ..
~~~

# MNE-NIRS

To run the MNE-NIRS pipeline you will need Python and a terminal window.

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

You will need MATLAB to run this toolbox.

Download the toolbox from the [nirs-toolbox repository](https://github.com/huppertt/nirs-toolbox).

Either select Code -> Download zip, or run..

~~~
cd <your_desired_toolbox_path>
git clone https://github.com/huppertt/nirs-toolbox.git
~~~

Add to MATLAB path via Home -> Set Path -> Add with subfolders -> select toolbox path.

Then open the `AnalyzIR_pipeline/AnalyzIR_pipeline.m` file and run it section by section.

# Homer3

You will need MATLAB to run this toolbox.

Download the toolbox from the [Homer3 repository](https://github.com/BUNPC/Homer3).

Either select Code -> Download zip, or run..

~~~
cd <your_desired_toolbox_path>
git clone https://github.com/BUNPC/Homer3.git
~~~

Add to MATLAB path via Home -> Set Path -> Add with subfolders -> select toolbox path.

We will basically follow the [BU neurophotonics tutorial](https://www.bu.edu/neurophotonics/files/2020/05/fNIRS_workshop_day1_BasicAnalysis.pdf).

Note that My Homer3 had issues with date time format on my computer so I had to change `Homer3\DataTree\AcquiredData\DataFilesFileClass.m` line 93 to 0. Maybe you won't have to.

This is GUI based. Steps to analyze the dataset:

- Copy over the BIDS dataset to Homer3_pipeline

- In MATLAB, make sure the current directory _is in_ the BIDS dataset

- Start Homer3 by running the command `Homer3` in the MATLAB command window

- Click cancel when it asks for a cfg file

Now you can click on the montage on the right and inspect the time series data. To run preprocessing and analysis: 

- Edit current processing stream (run level)

- Add GLM

- Save (save current processing stream)

- Click Run

- Wait for it to finish

- Select the condition of interest

- Now you can visualize the HRF

