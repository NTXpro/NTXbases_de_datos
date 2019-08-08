
CREATE PROC [ERP].[Usp_Ins_ResumenDiario] --'asd'
@Nombre VARCHAR(250)
AS
BEGIN
	INSERT INTO [ERP].[ResumenDiario](Nombre,Fecha) VALUES (@Nombre,GETDATE())

END