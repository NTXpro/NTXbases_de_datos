CREATE PROC [ERP].[Usp_Sel_Comparador_By_ID]
@ID INT
AS
BEGIN
SELECT [ID]
	  ,IdEstablecimiento
	  ,IdMoneda
	  ,IdAlmacen
	  ,TipoCambio	
      ,[Fecha]
      ,[Numero]
      ,[Nombre]
      ,[Descripcion]
      ,[UsuarioRegistro]
      ,[FechaRegistro]
      ,[UsuarioModifico]
      ,[FechaModificado]
      ,[IdEmpresa]
      ,[FlagBorrador]
      ,[Serie]
	  ,Flag
	  ,FlagGeneroOC
	  ,IdEmpresa
  FROM [ERP].[Comparador]
  WHERE ID = @ID
END