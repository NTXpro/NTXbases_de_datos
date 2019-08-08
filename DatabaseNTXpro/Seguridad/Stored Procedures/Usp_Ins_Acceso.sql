create PROC Seguridad.Usp_Ins_Acceso-- 2,1,1,'Nuevo'
@IdRol INT,
@IdPagina INT,
@Checked BIT,
@Accion VARCHAR(10)
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX);
	DECLARE @IdPaginaRol INT = (SELECT TOP 1 PR.ID FROM Seguridad.PaginaRol PR WHERE IdPagina = @IdPagina AND IdRol = @IdRol)
	
	
	IF @IdPaginaRol IS NULL 
		BEGIN
			SET @SQL = 'INSERT INTO Seguridad.PaginaRol(IdRol,IdPagina,'+ @Accion +')VALUES('+ CAST(@IdRol AS VARCHAR(100)) + ',' + CAST(@IdPagina AS VARCHAR(100)) + ','+ CAST(@Checked AS VARCHAR(100)) + ')';
			EXEC(@SQL)
		END
	ELSE	
		BEGIN
			SET @SQL = 'UPDATE Seguridad.PaginaRol SET '+ @Accion +' = ' +  CAST(@Checked AS VARCHAR(100)) + ' WHERE ID = '+  CAST(@IdPaginaRol AS VARCHAR(100));
			EXEC(@SQL)
		END

		
END