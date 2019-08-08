
CREATE PROC [ERP].[Usp_Upd_EstructuraCuatro]
@DATA XML,
@IdAnio INT,
@IdEmpresa INT,
@IdEstructuraTres INT,
@UsuarioRegistro VARCHAR(250),
@FechaRegistro DATETIME
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000
	
	DECLARE @TablaCuatro TABLE(ID INT, CuentaContable VARCHAR(50), Operador INT);

	BEGIN -- INSERTAR EN TABLA TEMPORARAL

		INSERT INTO @TablaCuatro
		SELECT
		T.N.value('ID[1]', 'INT'),
		T.N.value('CuentaContable[1]', 'VARCHAR(50)'),
		T.N.value('Operador[1]', 'INT')
		FROM
		@DATA.nodes('/EstructuraCuatro') AS T(N)

	END

	BEGIN -- INACTIVAR 
	
		UPDATE EBGC SET 
			EBGC.Flag = 0,
			EBGC.UsuarioElimino = @UsuarioRegistro,
			EBGC.FechaEliminado = @FechaRegistro
		FROM [ERP].[EstructuraCuatro] EBGC
		INNER JOIN [ERP].[EstructuraTres] EBGT ON EBGC.IdEstructuraTres = EBGT.ID
		INNER JOIN [ERP].[EstructuraDos] EBGD ON EBGT.IdEstructuraDos = EBGD.ID
		INNER JOIN [ERP].[EstructuraUno] EBGU ON EBGD.IdEstructuraUno = EBGU.ID
		WHERE
		EBGU.IdEmpresa = @IdEmpresa AND
		EBGC.ID NOT IN (SELECT ID FROM @TablaCuatro) AND
		EBGT.ID = @IdEstructuraTres;

	END

	BEGIN -- MODIFICAR 

		UPDATE EBGC SET 
		EBGC.CuentaContable = TC.CuentaContable,
		EBGC.Operador = TC.Operador,
		EBGC.UsuarioModifico = @UsuarioRegistro,
		EBGC.FechaModificado = @FechaRegistro
		FROM [ERP].[EstructuraCuatro] EBGC
		INNER JOIN @TablaCuatro TC ON EBGC.ID = TC.ID

	END

	BEGIN -- REGISTRAR 

		INSERT INTO [ERP].[EstructuraCuatro]
           ([IdEstructuraTres]
           ,[CuentaContable]
           ,[Operador]
           ,[Orden]
           ,[UsuarioRegistro]
           ,[FechaRegistro]
           ,[Flag])
		SELECT
			@IdEstructuraTres,
			PC.CuentaContable,
			TC.Operador,
			NULL,
			@UsuarioRegistro,
			@FechaRegistro,
			1
		FROM @TablaCuatro TC
		INNER JOIN ERP.PlanCuenta PC ON TC.CuentaContable = PC.CuentaContable AND PC.IdEmpresa = @IdEmpresa AND PC.IdAnio = @IdAnio
		WHERE ISNULL(TC.ID, 0) = 0

	END

	SELECT 1;
END
