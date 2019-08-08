create PROC ERP.Usp_Sel_Comparador
@IdEmpresa INT
AS
BEGIN
	SELECT [ID]
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
	  FROM [ERP].[Comparador]
	  WHERE IdEmpresa = @IdEmpresa
  END