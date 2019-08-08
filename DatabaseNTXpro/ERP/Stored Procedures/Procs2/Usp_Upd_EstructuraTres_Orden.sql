
CREATE PROC [ERP].[Usp_Upd_EstructuraTres_Orden]
@DATA XML,
@UsuarioModifico varchar(250),
@FechaModificado datetime
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000
	
	UPDATE EBGT SET
	EBGT.Orden = T.N.value('Orden[1]', 'INT'),
	EBGT.UsuarioModifico = @UsuarioModifico,
	EBGT.FechaModificado = @FechaModificado
	FROM [ERP].[EstructuraTres] EBGT
	INNER JOIN @DATA.nodes('/EstructuraTres') AS T(N) ON T.N.value('ID[1]', 'INT') = EBGT.ID

	SELECT 1;
END
