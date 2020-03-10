# TweezersAnalysis
Code to analyze optical tweezers data from single yeast nuclei. Formerly named "oscillations code" or "oscillations code 022414". Initial upload on 10/18/18 -- Jessica uploaded original code developed by Peter Koo and Yao Zhao; used by Sarah Schreiner for analyzing optical tweezers data for Schreiner et al., Nat. Comm., 2015.

# MATLAB analysis of optical tweezers/force spectroscopy data of isolated nuclei
(Written and updated 03/10/2020 by Jessica (Johnston) Williams)

Things needed to correctly perform analysis:

- MATLAB code package “TweezersAnalysis”
    - Mochrie Lab GitHub: https://github.com/mochrielab/TweezersAnalysis
    - Formerly named "oscillations code" or "oscillations code 022414"
- Tweezers experiment files:
    1) ‘_PowerSpectrum_001.txt’ - power spectrum data of free bead in optical trap (before attaching to nucleus)
      - Used to measure strength of trap
    2) ‘Manual_001.txt’ - QPD deflection readout vs. piezo x-position when bead is being attached to nucleus (“manual pull”)
      - Used to find starting x-position (point at which bead begins to be pushed out of optical trap and registers deflection      
      on QPD) for push-pull oscillations.
    3) ‘FileIndex.txt’ - list of oscillations with name, oscillation frequency, and data acquisition rate.
    4) ‘_001.txt’ - individual oscillation data
    5) ‘StuckBead.txt_BeadScan_001.txt’ - likely found in last data folder; bead scan performed at end of experiment to 
    measure trap displacement slope and location of trap.
    6) X, y, z drift tracing data - stored in ‘Drift’ folder as ‘***.txt’.

To perform analysis using MATLAB “Tweezers Analysis”:

1) Download “TweezersAnalysis” code from Mochrie Lab GitHub to computer.
2) Open MATLAB and add “TweezersAnalysis” folder to MATLAB path (including subfolders).
3) Open “TweezersAnalysis” folder in Current Folder.
4) Load “main_manualdrift_nofilter.m” into Editor (all other relevant functions are housed in ‘Functions’ folder; other functions are housed in ‘Archive’ folder).
5) Follow directions in “main_manualdrift_nofilter.m” script, section by section.
6) Outputs will be various text files of drift-corrected data and figures of oscillations; the final drift-corrected, converted force vs. extension by oscillation data will be written as ‘Fit.txt.’ 

