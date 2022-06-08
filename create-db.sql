USE master;  
GO 

CREATE DATABASE [KocsisHostel]
 ON  PRIMARY 
( NAME = N'KocsisHostel', 
FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\KocsisHostel.mdf' , 
SIZE = 8192KB , FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'KocsisHostel_log', 
FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Log\KocsisHostel_log.ldf' , 
SIZE = 8192KB , FILEGROWTH = 65536KB )
 COLLATE Hungarian_100_CI_AI
GO