This repository contains all materials, data and code to reproduce the analyses presented in our manuscript. It includes the study preregistration, the raw data, R scripts and R Markdown files used to generate the results. Below is an overview of the structure of this repository and a brief description of the files.

Data
The folder raw_data/ contains:
-	reporting.xlsx contains the dataset generated for reporting practices of pre-study power calculations and statistical results as well as the data that authors used to reproduce the pre-study power calculations.
-	zcurve_data.xlsx contains the dataset generated for z-curve analysis (including the studies excluded). 
-	coding_verification.xlsx contains the responses between two raters for the reporting practices of a priori power analysis.

Code
The folder r_scripts/ contains:
-	rp_f_tests.R contains the code to reproduce the results for the reporting practices of F-tests. 
-	rp_t_tests.R contains the code to reproduce the results for the reporting practices of t-tests.
-	rp_power.R contains the code to reproduce the results of the reporting practices of a-priori power analyses.
-	sample_size_differences contains the code to reproduce the results of the Poisson simple regression which was in turn used to investigate the difference in sample size between studies that used a-priori power analysis and those which did not.
-	zcurve.R contains the code to reproduce the results of the z-curve analysis. 
-	secondary_zcurve.R contains the code to reproduce the results of the secondary z-curve analysis.

Figures
The folder figures/ contains the 2 figures corresponding to the primary and secondary z-curves.

Materials
The folder materials/ contains:
-	Supplemental_results.docx contains the results from the secondary z-curve, the explanation as to why studies reporting a significant p-value in the contrary to the expected direction were excluded as we all a figure that shows the Poisson distribution of sample size data.
-	zcurve_protocol.docx contains both the study selection protocol and description of how p-values reported in the selected studies were extracted.

