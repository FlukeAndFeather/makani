## code to prepare `tracks` dataset goes here
`%>%` <- dplyr::`%>%`

wind_file <- "analysis/data/raw_data/WRF_HI/2014_WRF_Hawaii_Regional_Atmospheric_Model_best.ncd.nc"

if (!file.exists(wind_file)) {
  stop("Wind NetCDF file not found. Have you concatenated the file chunks? See 'analysis/data/raw_data/WRF_HI/reassembling-wind-NetCDF-file.md'")
}

extract_wind <- function(x, y, t) {
  windnc <- ncdf4::nc_open(wind_file)

  lon <- ncdf4::ncvar_get(windnc, varid = "lon")
  lat <- ncdf4::ncvar_get(windnc, varid = "lat")
  # units: hours since 2010-05-14 00:00:00.000 UTC
  time <- ncdf4::ncvar_get(windnc, varid = "time")
  t2 <- (t - as.POSIXct("2010-05-14", tz = "UTC")) %>%
    as.numeric(unit = "hours") %>%
    round()

  x_idx <- approx(lon, seq_along(lon), xout = x, method = "constant")$y
  y_idx <- approx(lat, seq_along(lat), xout = y, method = "constant")$y
  t_idx <- approx(time, seq_along(time), xout = t2, method = "constant")$y

  uwind <- ncdf4::ncvar_get(windnc, "Uwind")
  vwind <- ncdf4::ncvar_get(windnc, "Vwind")
  data.frame(Uwind = uwind[cbind(x_idx, y_idx, t_idx)],
             Vwind = vwind[cbind(x_idx, y_idx, t_idx)])
}

tracks <- "analysis/data/raw_data/tracks.csv" %>%
  readr::read_csv() %>%
  dplyr::mutate(wind = extract_wind(Longitude, Latitude, TimestampUTC)) %>%
  tidyr::unpack(wind)

usethis::use_data(tracks, overwrite = TRUE)
