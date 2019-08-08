
CREATE PROC [ERP].[Usp_Sel_MovimientoConciliacion_By_ID]
@ID INT
AS
BEGIN
	SELECT MC.ID
		  ,MC.IdCuenta
		  ,MC.IdPeriodo
		  ,MC.Fecha
		  ,MC.BancoSaldoAnterior
		  ,MC.BancoIngreso
		  ,MC.BancoEgreso
		  ,MC.BancoSaldo
		  ,MC.ConciliadoIngreso
		  ,MC.ConciliadoEgreso
		  ,MC.DifiereIngreso
		  ,MC.DifiereEgreso
		  ,MC.LibroSaldoAnterior
		  ,MC.LibroIngreso
		  ,MC.LibroEgreso
		  ,MC.LibroSaldo
		  ,MC.Flag
		  ,MC.FlagConciliado
		  ,A.Nombre Anio
		  ,M.ID Mes
		  ,(SELECT [ERP].[ObtenerNombreBancoMonedaTipo_By_IdCuenta] (MC.IdCuenta)) Cuenta
		  ,(ETD.NumeroDocumento + ' - ' + EN.Nombre) Empresa
	  FROM ERP.MovimientoConciliacion MC
	  INNER JOIN ERP.Empresa E ON E.ID = MC.IdEmpresa
	  INNER JOIN ERP.Entidad EN ON EN.ID = E.IdEntidad
	  INNER JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = E.IdEntidad
	  INNER JOIN ERP.Periodo P ON P.ID = MC.IdPeriodo
	  INNER JOIN Maestro.Anio A ON A.ID = P.IdAnio
	  INNER JOIN Maestro.Mes M ON M.ID = P.IdMes
	  WHERE MC.ID = @ID
END