

eram_site <- function(segment_id, type, con) {
  
  if (type == 'S') {
    
    eram_segment_id <- segment_id
    
    query <- qq(read_file("../queries/category_eram_segment_site_id.sql"))
    
    eram_site_id <- dbGetQuery(con, query)[1,1]
    
  } else {
    
    eram_category_id <- segment_id
    
    query <- qq(read_file("../queries/category_eram_category_site_id.sql"))
    
    eram_site_id <- dbGetQuery(con, query)[1,1]
    
  }
  
  return(eram_site_id)
  
}