liquor <- read.csv("../Liquor_Authority_Quarterly_List_of_Active_Licenses.csv")
liquor_nyc <- filter(liquor, County.Name..Licensee. == "NEW YORK" | # Manhattan
                             County.Name..Licensee. == "RICHMOND" | # Staten Island
                             County.Name..Licensee. == "BRONX" |    # Bronx
                             County.Name..Licensee. == "KINGS" |    # Brooklyn
                             County.Name..Licensee. == "QUEENS")    # Queens
liquor_nyc_bars <- filter(liquor_nyc, License.Type.Name == "ON-PREMISES LIQUOR")
write.csv(liquor_nyc_bars, "nyc_bars.csv")
