The NetCDF file containing the wind vector data is too large for GitHub, so I split it into three parts ('windchunks\*'). This was done on a Mac by:

    split -b 50m analysis/data/raw_data/WRF_HI/2014_WRF_Hawaii_Regional_Atmospheric_Model_best.ncd.nc analysis/data/raw_data/WRF_HI/windchunks

You can reassemble it from a Unix-based command line with:

    cat `ls analysis/data/raw_data/WRF_HI/windchunks*` > analysis/data/raw_data/WRF_HI/2014_WRF_Hawaii_Regional_Atmospheric_Model_best.ncd.nc
