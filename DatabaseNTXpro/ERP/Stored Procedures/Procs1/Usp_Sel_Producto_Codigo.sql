CREATE PROCEDURE [ERP].[Usp_Sel_Producto_Codigo]

@IdEmpresa int
AS
BEGIN

                              SELECT * 
                                FROM(SELECT	
	                                    PRO.ID,
	                                    PRO.Nombre,
	                                    T6U.CodigoSunat AS UnidadMedida,
	                                    T5E.CodigoSunat AS CodigoExistencia,
	                                    PRO.FechaRegistro,
	                                    T6U.Nombre AS NombreUnidadMedida,
	                                    PRO.FechaEliminado,
	                                    PRO.CodigoReferencia,
                                        ISNULL(PV.CuentaContable,'') CuentaContableVenta,
                                        ISNULL(PC.CuentaContable,'') CuentaContableCompra,
		                                PRO.Flag,
		                                PRO.FlagBorrador,
		                                PRO.IdEmpresa,
		                                PRO.IdTipoProducto
                                    FROM [ERP].[Producto] PRO
                                    LEFT JOIN PLE.T6UnidadMedida T6U ON PRO.IdUnidadMedida=T6U.ID
                                    LEFT JOIN Maestro.Marca MA ON PRO.IdMarca = MA.ID
                                    LEFT JOIN PLE.T5Existencia T5E ON PRO.IdExistencia  = T5E.ID
                                    LEFT JOIN Maestro.TipoProducto TP ON PRO.IdTipoProducto=TP.ID
                                    LEFT JOIN ERP.Empresa EM ON EM.ID=PRO.IdEmpresa
                                    LEFT JOIN ERP.PlanCuenta PV ON PV.ID = PRO.IdPlanCuenta
                                    LEFT JOIN ERP.PlanCuenta PC ON PC.ID = PRO.IdPlanCuentaCompra
                                    ) TEMP 
	                                WHERE 
                                
                                    TEMP.FlagBorrador = 0 AND
                                    TEMP.IdEmpresa = @IdEmpresa AND
                                    TEMP.IdTipoProducto= 1
									end