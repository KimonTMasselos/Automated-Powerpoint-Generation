#---- CONNECT TO ERA MARKETPLACE LOCAL DB ----

connect_eramdb <- function(password) {
  
  sslmode <- "verify-ca"
  sslrootcert <- "server-ca.pem"
  sslcert <- "client-cert.pem"
  sslkey <- "client-key.pem"
  
  ## Connect to eRA Local App database
  dbConnect(Postgres(),
            dbname = "marketplace_production",
            host = "34.22.181.119",
            port = 5432,
            user = "mplace_user",
            password = password,
            bigint = "numeric",
            sslmode = sslmode,
            sslrootcert = sslrootcert,
            sslcert = sslcert,
            sslkey = sslkey)
}