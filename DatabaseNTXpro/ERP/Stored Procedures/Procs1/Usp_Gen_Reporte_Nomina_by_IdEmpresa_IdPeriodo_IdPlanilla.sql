

----------------
-----
-- Stored Procedure

-- =============================================
-- Author:		OMAR RODRIGUEZ
-- Create date: 04/01/2018
-- Description:	REPORTE PLANILLA NOMINA
-- =============================================
CREATE PROCEDURE [ERP].[Usp_Gen_Reporte_Nomina_by_IdEmpresa_IdPeriodo_IdPlanilla]
@IdEmpresa  int  null,
@IdPeriodo  int  null,
@IdPlanilla  int NULL,
@FechaPlanillaInicio  datetime null,
@FechaPlanillaFin  datetime null
AS
BEGIN




--- CURSOR PARA RECORRER LA CABECERA DE PAGO
DECLARE @IdTrabajador AS INT= 0;
DECLARE @IdCabecera AS INT= 0;
DECLARE @IdDld AS INT= 0;
DECLARE @IdPivot AS INT= 0;

DECLARE @qry03 AS nvarchar(max)=''
DECLARE @qry04 AS nvarchar(max)=''
DECLARE @Ind AS int = 0
DECLARE @inicio  nvarchar(max)='EMPLEADO/CONCEPTOS'
DECLARE @nombreConcepto AS nvarchar(max) = ''

TRUNCATE TABLE [ERP].[ReporteNomina]
DECLARE @PCEN int =(SELECT  TOP 1 pc.ID  FROM ERP.PlanillaCabecera pc
								INNER JOIN ERP.PlanillaPago pp ON pp.IdPlanillaCabecera = pc.ID
								WHERE pc.IdEmpresa = @IdEmpresa  AND pc.IdPlanilla = @IdPlanilla AND pc.FechaInicio =@FechaPlanillaInicio AND pc.FechaFin = @FechaPlanillaFin
								GROUP BY pp.IdPlanillaCabecera , pc.id
								ORDER BY COUNT(pp.IdConcepto)  DESC)

-- LLENADO DE LOS NOMBRES DE LOS CONCEPTOS  ----------------------------
DECLARE ConceptoInfo CURSOR FOR SELECT c.Nombre FROM ERP.PlanillaPago pp INNER JOIN  ERP.Concepto c ON pp.IdConcepto = c.ID 
									WHERE pp.IdPlanillaCabecera=@PCEN    ORDER BY pp.IdPlanillaCabecera, c.Orden
OPEN ConceptoInfo
	FETCH NEXT FROM ConceptoInfo INTO @nombreConcepto
	WHILE @@fetch_status = 0
		BEGIN
			IF @nombreConcepto IS NULL
			BEGIN
			SET  @nombreConcepto = 'N/A'
			END
			SET @Ind = @Ind + 1
			SET @qry03 = @qry03+'['+cast(@Ind AS varchar(4))+'],'
			SET @qry04 = @qry04 + '''' +cast(@nombreConcepto AS nvarchar(30))+ ''','
			FETCH NEXT FROM ConceptoInfo INTO @nombreConcepto
		END

	IF Len(@qry03)>1
	BEGIN
		SET @qry03 = SUBSTRING (@qry03, 1, Len(@qry03) - 1 )
	END
	IF Len(@qry04)>1
	BEGIN
		SET @qry04 =  SUBSTRING (@qry04, 1, Len(@qry04) - 1 )
	END
	IF @Ind >0 
	BEGIN
	DECLARE @InnerSQLConcepto varchar(max)
	SET @InnerSQLConcepto= 'INSERT INTO [ERP].[ReporteNomina]([NumeroDocumento],[TipoDocumento]
			      ,[NombreEmpleado],[RegimenPensionario],[CargoEmpleado],[FechaIniDatoLaboral],[FechaFinDatoLaboral]
			      ,[FechaCese],[Sueldo],[HoraBase],'+cast(@qry03 AS varchar(1000))+') VALUES (''NUMERO DOC.'',''TIPO'',''.APELLIDOS Y NOMBRES'',''REGIMEN'',''CARGO'',''FECHA INICO'',''FECHA FIN'',''FECHA CESE'',''SUELDO'',''HORA BASE'','+@qry04+')'

			  EXEC ( @InnerSQLConcepto)
	--EXEC( 'INSERT INTO [ERP].[ReporteNominaCabecera](inicio,'+@qry03+') VALUES ('''+@inicio+''','+@qry04+')')
	END

CLOSE ConceptoInfo
DEALLOCATE ConceptoInfo   
-----------------------------------------------------------------------

IF @Ind >0 
BEGIN


DECLARE PlanillaCaInfo CURSOR FOR SELECT pc.ID, pc.IdTrabajador, dld.ID  FROM ERP.PlanillaCabecera pc
								INNER JOIN ERP.DatoLaboralDetalle dld ON pc.IdDatoLaboralDetalle = dld.ID
								WHERE pc.IdEmpresa = @IdEmpresa   AND pc.IdPlanilla = @IdPlanilla AND pc.FechaInicio =@FechaPlanillaInicio AND pc.FechaFin = @FechaPlanillaFin;
OPEN PlanillaCaInfo;
FETCH NEXT FROM PlanillaCaInfo INTO @IdCabecera,@IdTrabajador,@IdDld
WHILE @@fetch_status = 0
    BEGIN
		DECLARE @IdPC AS int=0
		DECLARE @IdCo AS int =0
		DECLARE @IdCal AS decimal(14,6)=0
		DECLARE @qry01 AS nvarchar(max)=''
		DECLARE @qry02 AS nvarchar(max)=''
		DECLARE @Indice AS int = 0
		DECLARE @nombre AS nvarchar(max) = ''
		--- DATOS DEL TRABAJADOR --------
			DECLARE @NumeroDocumento INT =0
			DECLARE @AbreviaturaDOC varchar(20) = ''
			DECLARE @TipoDocumento varchar(20) = ''
			DECLARE @Regimen varchar(20) = ''
			DECLARE @CargoEmpleado varchar(150) =''
			DECLARE @nombreCompleto nvarchar(max) = ''
			DECLARE @HoraBase varchar(20) = ''
			DECLARE @FechaCese VARCHAR(20)= ''
			DECLARE @Sueldo  decimal(14,2)=0
			DECLARE @FechaInicioDLD  VARCHAR(20)= ''
			DECLARE @FechaFinDLD  VARCHAR(20)= ''

			SELECT TOP 1  @NumeroDocumento = etd.NumeroDocumento,  @AbreviaturaDOC=td.Abreviatura, @nombreCompleto = (p.ApellidoPaterno+' '+p.ApellidoMaterno+' '+p.Nombre), @HoraBase=CAST (dld.HoraBase AS NUMERIC(18,2)), 
							@FechaCese = CONVERT(VARCHAR(10), ISNULL(dl.FechaCese,'1900-01-01') , 103), @Sueldo = CAST(dld.Sueldo AS NUMERIC(18,2)), @FechaInicioDLD = CONVERT(VARCHAR(10), dld.FechaInicio, 103) , @FechaFinDLD =CONVERT(VARCHAR(10), ISNULL(dlD.FECHAFIN,'1900-01-01') , 103)
							,@CargoEmpleado =isnull(p2.Nombre, 'N/A')
							FROM ERP.PlanillaCabecera pc  INNER JOIN ERP.DatoLaboralDetalle dld ON pc.IdDatoLaboralDetalle = dld.ID
														INNER JOIN ERP.DatoLaboral dl ON dld.IdDatoLaboral = dl.ID
														INNER JOIN ERP.Trabajador t ON dl.IdTrabajador = t.ID
														INNER JOIN ERP.Persona p ON t.IdEntidad = p.IdEntidad
														INNER JOIN ERP.EntidadTipoDocumento etd ON p.IdEntidad = etd.IdEntidad
														INNER JOIN PLE.T2TipoDocumento td ON etd.IdTipoDocumento = td.ID
														INNER JOIN Maestro.Puesto p2 ON dld.IdPuesto = p2.ID
														WHERE  dld.ID =@IdDld--   pc.IdEmpresa = @IdEmpresa AND pc.IdPeriodo = @IdPeriodo AND pc.IdPlanilla = @IdPlanilla

			SELECT @Regimen= tp2.Abreviatura FROM ERP.DatoLaboralDetalle dld INNER JOIN ERP.DatoLaboral dl ON dld.IdDatoLaboral = dl.ID
														INNER JOIN ERP.TrabajadorPension tp ON dl.IdTrabajador = tp.IdTrabajador
														INNER JOIN plame.T11RegimenPensionario tp2 ON tp2.ID = tp.IdRegimenPensionario
															WHERE tp.FechaInicio>=dld.FechaInicio AND ( tp.FechaFin <= dld.FechaFin OR tp.FechaFin IS null)
															AND dld.ID =@IdDld

        SELECT @Regimen = isnull(@Regimen,' ')

		---------------------------------
		DECLARE ConceptoInfo CURSOR FOR SELECT pp.IdPlanillaCabecera, pp.IdConcepto, isnull(pp.Calculo,0) AS Calculo  FROM ERP.PlanillaPago pp INNER JOIN  ERP.Concepto c ON pp.IdConcepto = c.ID 
										 WHERE pp.IdPlanillaCabecera=@PCEN ORDER BY pp.IdPlanillaCabecera, c.Orden
		OPEN ConceptoInfo
			FETCH NEXT FROM ConceptoInfo INTO @IdPC,@IdCo,@IdCal
			WHILE @@fetch_status = 0
				BEGIN
				    DECLARE @ValorCalculo decimal(14,6)
					SET @ValorCalculo = isnull( (SELECT pp.Calculo FROM ERP.PlanillaPago pp WHERE pp.IdPlanillaCabecera = @IdCabecera AND pp.IdConcepto = @IdCo),0)

					SET @Indice = @Indice + 1
					SET @qry01 = @qry01+'['+cast(@Indice AS varchar(4))+'],'
					SET @qry02 = @qry02 + cast( CAST(@ValorCalculo AS DECIMAL(15,2)) AS nvarchar(30))+ ','

					FETCH NEXT FROM ConceptoInfo INTO @IdPC,@IdCo,@IdCal
				END

			IF Len(@qry01)>1
			BEGIN
				SET @qry01 = SUBSTRING (@qry01, 1, Len(@qry01) - 1 )
			END
			IF Len(@qry02)>1
			BEGIN

				SET @qry02 =  SUBSTRING (@qry02, 1, Len(@qry02) - 1 )
			END
			DECLARE @InnerSQL varchar(max) = ''


				BEGIN TRY  
						SET @InnerSQL= 'INSERT INTO [ERP].[ReporteNomina]([NumeroDocumento],[TipoDocumento]
			      ,[NombreEmpleado],[RegimenPensionario],[CargoEmpleado],[FechaIniDatoLaboral],[FechaFinDatoLaboral]
			      ,[FechaCese],[Sueldo],[HoraBase],'+@qry01+') VALUES ('+cast(@NumeroDocumento AS varchar(20))+','''+@AbreviaturaDOC+''','''+@nombreCompleto+''','''+@Regimen+''','''+@CargoEmpleado+''','''+@FechaInicioDLD+''','''+@FechaFinDLD+''','''+@FechaCese+''','+cast(@Sueldo AS varchar(20))+','+cast(@HoraBase AS varchar(20))+','+@qry02+')'

				EXEC ( @InnerSQL)


				END TRY
				BEGIN CATCH
					SELECT ERROR_NUMBER() AS ErrorNumber, 
						   ERROR_MESSAGE() AS ErrorMessage;
				END CATCH;

		CLOSE ConceptoInfo
		DEALLOCATE ConceptoInfo   
        FETCH NEXT FROM PlanillaCaInfo INTO @IdCabecera,@IdTrabajador,@IdDld;
    END;
CLOSE PlanillaCaInfo;
DEALLOCATE PlanillaCaInfo;
END
---------- TOTALES --------------------------------------------------------------
INSERT ERP.ReporteNomina
(
	[NombreEmpleado],
    [HoraBase],
    [1],
    [2],
    [3],
    [4],
    [5],
    [6],
    [7],
    [8],
    [9],
    [10],
    [11],
    [12],
    [13],
    [14],
    [15],
    [16],
    [17],
    [18],
    [19],
    [20],
    [21],
    [22],
    [23],
    [24],
    [25],
    [26],
    [27],
    [28],
    [29],
    [30],
    [31],
    [32],
    [33],
    [34],
    [35],
    [36],
    [37],
    [38],
    [39],
    [40],
    [41],
    [42],
    [43],
    [44],
    [45],
    [46],
    [47],
    [48],
    [49],
    [50],
    [51],
    [52],
    [53],
    [54],
    [55],
    [56],
    [57],
    [58],
    [59],
    [60],
    [61],
    [62],
    [63],
    [64],
    [65],
    [66],
    [67],
    [68],
    [69],
    [70],
    [71],
    [72],
    [73],
    [74],
    [75],
    [76],
    [77],
    [78],
    [79],
    [80],
    [81],
    [82],
    [83],
    [84],
    [85],
    [86],
    [87],
    [88],
    [89],
    [90],
    [91],
    [92],
    [93],
    [94],
    [95],
    [96],
    [97],
    [98],
    [99],
    [100],
    [101],
    [102],
    [103],
    [104],
    [105],
    [106],
    [107],
    [108],
    [109],
    [110],
    [111],
    [112],
    [113],
    [114],
    [115],
    [116],
    [117],
    [118],
    [119],
    [120],
    [121],
    [122],
    [123],
    [124],
    [125],
    [126],
    [127],
    [128],
    [129],
    [130],
    [131],
    [132],
    [133],
    [134],
    [135],
    [136],
    [137],
    [138],
    [139],
    [140],
    [141],
    [142],
    [143],
    [144],
    [145],
    [146],
    [147],
    [148],
    [149],
    [150],
    [151],
    [152],
    [153],
    [154],
    [155],
    [156],
    [157],
    [158],
    [159],
    [160],
    [161],
    [162],
    [163],
    [164],
    [165],
    [166],
    [167],
    [168],
    [169],
    [170],
    [171],
    [172],
    [173],
    [174],
    [175],
    [176],
    [177],
    [178],
    [179],
    [180],
    [181],
    [182],
    [183],
    [184],
    [185],
    [186],
    [187],
    [188],
    [189],
    [190],
    [191],
    [192],
    [193],
    [194],
    [195],
    [196],
    [197],
    [198],
    [199],
    [200]
)

SELECT 'ZZZZ' AS NombreEmpleado, 'TOTALES' AS HoraBase,
cast(sum(cast(A.[1] AS numeric(18,2))) AS varchar(20)) AS [1]
,cast(sum(cast(A.[2] AS numeric(18,2))) AS varchar(20)) AS [2]
,cast(sum(cast(A.[3] AS numeric(18,2))) AS varchar(20)) AS [3] 
,cast(sum(cast(A.[4] AS numeric(18,2))) AS varchar(20)) AS [4]
,cast(sum(cast(A.[5] AS numeric(18,2))) AS varchar(20)) AS [5]
,cast(sum(cast(A.[6] AS numeric(18,2))) AS varchar(20)) AS [6]
,cast(sum(cast(A.[7] AS numeric(18,2))) AS varchar(20)) AS [7]
,cast(sum(cast(A.[8] AS numeric(18,2))) AS varchar(20)) AS [8]
,cast(sum(cast(A.[9] AS numeric(18,2))) AS varchar(20)) AS [9]
,cast(sum(cast(A.[10] AS numeric(18,2))) AS varchar(20)) AS [10]
,cast(sum(cast(A.[11] AS numeric(18,2))) AS varchar(20)) AS [11]
,cast(sum(cast(A.[12] AS numeric(18,2))) AS varchar(20)) AS [12]
,cast(sum(cast(A.[13] AS numeric(18,2))) AS varchar(20)) AS [13]
,cast(sum(cast(A.[14] AS numeric(18,2))) AS varchar(20)) AS [14]
,cast(sum(cast(A.[15] AS numeric(18,2))) AS varchar(20)) AS [15]
,cast(sum(cast(A.[16] AS numeric(18,2))) AS varchar(20)) AS [16]
,cast(sum(cast(A.[17] AS numeric(18,2))) AS varchar(20)) AS [17]
,cast(sum(cast(A.[18] AS numeric(18,2))) AS varchar(20)) AS [18]
,cast(sum(cast(A.[19] AS numeric(18,2))) AS varchar(20)) AS [19]
,cast(sum(cast(A.[20] AS numeric(18,2))) AS varchar(20)) AS [20]
,cast(sum(cast(A.[21] AS numeric(18,2))) AS varchar(20)) AS [21]
,cast(sum(cast(A.[22] AS numeric(18,2))) AS varchar(20)) AS [22]
,cast(sum(cast(A.[23] AS numeric(18,2))) AS varchar(20)) AS [23]
,cast(sum(cast(A.[24] AS numeric(18,2))) AS varchar(20)) AS [24]
,cast(sum(cast(A.[25] AS numeric(18,2))) AS varchar(20)) AS [25]
,cast(sum(cast(A.[26] AS numeric(18,2))) AS varchar(20)) AS [26]
,cast(sum(cast(A.[27] AS numeric(18,2))) AS varchar(20)) AS [27]
,cast(sum(cast(A.[28] AS numeric(18,2))) AS varchar(20)) AS [28]
,cast(sum(cast(A.[29] AS numeric(18,2))) AS varchar(20)) AS [29]
,cast(sum(cast(A.[30] AS numeric(18,2))) AS varchar(20)) AS [30]
,cast(sum(cast(A.[31] AS numeric(18,2))) AS varchar(20)) AS [31]
,cast(sum(cast(A.[32] AS numeric(18,2))) AS varchar(20)) AS [32]
,cast(sum(cast(A.[33] AS numeric(18,2))) AS varchar(20)) AS [33]
,cast(sum(cast(A.[34] AS numeric(18,2))) AS varchar(20)) AS [34]
,cast(sum(cast(A.[35] AS numeric(18,2))) AS varchar(20)) AS [35]
,cast(sum(cast(A.[36] AS numeric(18,2))) AS varchar(20)) AS [36]
,cast(sum(cast(A.[37] AS numeric(18,2))) AS varchar(20)) AS [37]
,cast(sum(cast(A.[38] AS numeric(18,2))) AS varchar(20)) AS [38]
,cast(sum(cast(A.[39] AS numeric(18,2))) AS varchar(20)) AS [39]
,cast(sum(cast(A.[40] AS numeric(18,2))) AS varchar(20)) AS [40]
,cast(sum(cast(A.[41] AS numeric(18,2))) AS varchar(20)) AS [41]
,cast(sum(cast(A.[42] AS numeric(18,2))) AS varchar(20)) AS [42]
,cast(sum(cast(A.[43] AS numeric(18,2))) AS varchar(20)) AS [43]
,cast(sum(cast(A.[44] AS numeric(18,2))) AS varchar(20)) AS [44]
,cast(sum(cast(A.[45] AS numeric(18,2))) AS varchar(20)) AS [45]
,cast(sum(cast(A.[46] AS numeric(18,2))) AS varchar(20)) AS [46]
,cast(sum(cast(A.[47] AS numeric(18,2))) AS varchar(20)) AS [47]
,cast(sum(cast(A.[48] AS numeric(18,2))) AS varchar(20)) AS [48]
,cast(sum(cast(A.[49] AS numeric(18,2))) AS varchar(20)) AS [49]
,cast(sum(cast(A.[50] AS numeric(18,2))) AS varchar(20)) AS [50]
,cast(sum(cast(A.[51] AS numeric(18,2))) AS varchar(20)) AS [51]
,cast(sum(cast(A.[52] AS numeric(18,2))) AS varchar(20)) AS [52]
,cast(sum(cast(A.[53] AS numeric(18,2))) AS varchar(20)) AS [53]
,cast(sum(cast(A.[54] AS numeric(18,2))) AS varchar(20)) AS [54]
,cast(sum(cast(A.[55] AS numeric(18,2))) AS varchar(20)) AS [55]
,cast(sum(cast(A.[56] AS numeric(18,2))) AS varchar(20)) AS [56]
,cast(sum(cast(A.[57] AS numeric(18,2))) AS varchar(20)) AS [57]
,cast(sum(cast(A.[58] AS numeric(18,2))) AS varchar(20)) AS [58]
,cast(sum(cast(A.[59] AS numeric(18,2))) AS varchar(20)) AS [59]
,cast(sum(cast(A.[60] AS numeric(18,2))) AS varchar(20)) AS [60]
,cast(sum(cast(A.[61] AS numeric(18,2))) AS varchar(20)) AS [61]
,cast(sum(cast(A.[62] AS numeric(18,2))) AS varchar(20)) AS [62]
,cast(sum(cast(A.[63] AS numeric(18,2))) AS varchar(20)) AS [63]
,cast(sum(cast(A.[64] AS numeric(18,2))) AS varchar(20)) AS [64]
,cast(sum(cast(A.[65] AS numeric(18,2))) AS varchar(20)) AS [65]
,cast(sum(cast(A.[66] AS numeric(18,2))) AS varchar(20)) AS [66]
,cast(sum(cast(A.[67] AS numeric(18,2))) AS varchar(20)) AS [67]
,cast(sum(cast(A.[68] AS numeric(18,2))) AS varchar(20)) AS [68]
,cast(sum(cast(A.[69] AS numeric(18,2))) AS varchar(20)) AS [69]
,cast(sum(cast(A.[70] AS numeric(18,2))) AS varchar(20)) AS [70]
,cast(sum(cast(A.[71] AS numeric(18,2))) AS varchar(20)) AS [71]
,cast(sum(cast(A.[72] AS numeric(18,2))) AS varchar(20)) AS [72]
,cast(sum(cast(A.[73] AS numeric(18,2))) AS varchar(20)) AS [73]
,cast(sum(cast(A.[74] AS numeric(18,2))) AS varchar(20)) AS [74]
,cast(sum(cast(A.[75] AS numeric(18,2))) AS varchar(20)) AS [75]
,cast(sum(cast(A.[76] AS numeric(18,2))) AS varchar(20)) AS [76]
,cast(sum(cast(A.[77] AS numeric(18,2))) AS varchar(20)) AS [77]
,cast(sum(cast(A.[78] AS numeric(18,2))) AS varchar(20)) AS [78]
,cast(sum(cast(A.[79] AS numeric(18,2))) AS varchar(20)) AS [79]
,cast(sum(cast(A.[80] AS numeric(18,2))) AS varchar(20)) AS [80]
,cast(sum(cast(A.[81] AS numeric(18,2))) AS varchar(20)) AS [81]
,cast(sum(cast(A.[82] AS numeric(18,2))) AS varchar(20)) AS [82]
,cast(sum(cast(A.[83] AS numeric(18,2))) AS varchar(20)) AS [83]
,cast(sum(cast(A.[84] AS numeric(18,2))) AS varchar(20)) AS [84]
,cast(sum(cast(A.[85] AS numeric(18,2))) AS varchar(20)) AS [85]
,cast(sum(cast(A.[86] AS numeric(18,2))) AS varchar(20)) AS [86]
,cast(sum(cast(A.[87] AS numeric(18,2))) AS varchar(20)) AS [87]
,cast(sum(cast(A.[88] AS numeric(18,2))) AS varchar(20)) AS [88]
,cast(sum(cast(A.[89] AS numeric(18,2))) AS varchar(20)) AS [89]
,cast(sum(cast(A.[90] AS numeric(18,2))) AS varchar(20)) AS [90]
,cast(sum(cast(A.[91] AS numeric(18,2))) AS varchar(20)) AS [91]
,cast(sum(cast(A.[92] AS numeric(18,2))) AS varchar(20)) AS [92]
,cast(sum(cast(A.[93] AS numeric(18,2))) AS varchar(20)) AS [93]
,cast(sum(cast(A.[94] AS numeric(18,2))) AS varchar(20)) AS [94]
,cast(sum(cast(A.[95] AS numeric(18,2))) AS varchar(20)) AS [95]
,cast(sum(cast(A.[96] AS numeric(18,2))) AS varchar(20)) AS [96]
,cast(sum(cast(A.[97] AS numeric(18,2))) AS varchar(20)) AS [97]
,cast(sum(cast(A.[98] AS numeric(18,2))) AS varchar(20)) AS [98]
,cast(sum(cast(A.[99] AS numeric(18,2))) AS varchar(20)) AS [99]
,cast(sum(cast(A.[100] AS numeric(18,2))) AS varchar(20)) AS [100]
,cast(sum(cast(A.[101] AS numeric(18,2))) AS varchar(20)) AS [101]
,cast(sum(cast(A.[102] AS numeric(18,2))) AS varchar(20)) AS [102]
,cast(sum(cast(A.[103] AS numeric(18,2))) AS varchar(20)) AS [103]
,cast(sum(cast(A.[104] AS numeric(18,2))) AS varchar(20)) AS [104]
,cast(sum(cast(A.[105] AS numeric(18,2))) AS varchar(20)) AS [105]
,cast(sum(cast(A.[106] AS numeric(18,2))) AS varchar(20)) AS [106]
,cast(sum(cast(A.[107] AS numeric(18,2))) AS varchar(20)) AS [107]
,cast(sum(cast(A.[108] AS numeric(18,2))) AS varchar(20)) AS [108]
,cast(sum(cast(A.[109] AS numeric(18,2))) AS varchar(20)) AS [109]
,cast(sum(cast(A.[110] AS numeric(18,2))) AS varchar(20)) AS [110]
,cast(sum(cast(A.[111] AS numeric(18,2))) AS varchar(20)) AS [111]
,cast(sum(cast(A.[112] AS numeric(18,2))) AS varchar(20)) AS [112]
,cast(sum(cast(A.[113] AS numeric(18,2))) AS varchar(20)) AS [113]
,cast(sum(cast(A.[114] AS numeric(18,2))) AS varchar(20)) AS [114]
,cast(sum(cast(A.[115] AS numeric(18,2))) AS varchar(20)) AS [115]
,cast(sum(cast(A.[116] AS numeric(18,2))) AS varchar(20)) AS [116]
,cast(sum(cast(A.[117] AS numeric(18,2))) AS varchar(20)) AS [117]
,cast(sum(cast(A.[118] AS numeric(18,2))) AS varchar(20)) AS [118]
,cast(sum(cast(A.[119] AS numeric(18,2))) AS varchar(20)) AS [119]
,cast(sum(cast(A.[120] AS numeric(18,2))) AS varchar(20)) AS [120]
,cast(sum(cast(A.[121] AS numeric(18,2))) AS varchar(20)) AS [121]
,cast(sum(cast(A.[122] AS numeric(18,2))) AS varchar(20)) AS [122]
,cast(sum(cast(A.[123] AS numeric(18,2))) AS varchar(20)) AS [123]
,cast(sum(cast(A.[124] AS numeric(18,2))) AS varchar(20)) AS [124]
,cast(sum(cast(A.[125] AS numeric(18,2))) AS varchar(20)) AS [125]
,cast(sum(cast(A.[126] AS numeric(18,2))) AS varchar(20)) AS [126]
,cast(sum(cast(A.[127] AS numeric(18,2))) AS varchar(20)) AS [127]
,cast(sum(cast(A.[128] AS numeric(18,2))) AS varchar(20)) AS [128]
,cast(sum(cast(A.[129] AS numeric(18,2))) AS varchar(20)) AS [129]
,cast(sum(cast(A.[130] AS numeric(18,2))) AS varchar(20)) AS [130]
,cast(sum(cast(A.[131] AS numeric(18,2))) AS varchar(20)) AS [131]
,cast(sum(cast(A.[132] AS numeric(18,2))) AS varchar(20)) AS [132]
,cast(sum(cast(A.[133] AS numeric(18,2))) AS varchar(20)) AS [133]
,cast(sum(cast(A.[134] AS numeric(18,2))) AS varchar(20)) AS [134]
,cast(sum(cast(A.[135] AS numeric(18,2))) AS varchar(20)) AS [135]
,cast(sum(cast(A.[136] AS numeric(18,2))) AS varchar(20)) AS [136]
,cast(sum(cast(A.[137] AS numeric(18,2))) AS varchar(20)) AS [137]
,cast(sum(cast(A.[138] AS numeric(18,2))) AS varchar(20)) AS [138]
,cast(sum(cast(A.[139] AS numeric(18,2))) AS varchar(20)) AS [139]
,cast(sum(cast(A.[140] AS numeric(18,2))) AS varchar(20)) AS [140]
,cast(sum(cast(A.[141] AS numeric(18,2))) AS varchar(20)) AS [141]
,cast(sum(cast(A.[142] AS numeric(18,2))) AS varchar(20)) AS [142]
,cast(sum(cast(A.[143] AS numeric(18,2))) AS varchar(20)) AS [143]
,cast(sum(cast(A.[144] AS numeric(18,2))) AS varchar(20)) AS [144]
,cast(sum(cast(A.[145] AS numeric(18,2))) AS varchar(20)) AS [145]
,cast(sum(cast(A.[146] AS numeric(18,2))) AS varchar(20)) AS [146]
,cast(sum(cast(A.[147] AS numeric(18,2))) AS varchar(20)) AS [147]
,cast(sum(cast(A.[148] AS numeric(18,2))) AS varchar(20)) AS [148]
,cast(sum(cast(A.[149] AS numeric(18,2))) AS varchar(20)) AS [149]
,cast(sum(cast(A.[150] AS numeric(18,2))) AS varchar(20)) AS [150]
,cast(sum(cast(A.[151] AS numeric(18,2))) AS varchar(20)) AS [151]
,cast(sum(cast(A.[152] AS numeric(18,2))) AS varchar(20)) AS [152]
,cast(sum(cast(A.[153] AS numeric(18,2))) AS varchar(20)) AS [153]
,cast(sum(cast(A.[154] AS numeric(18,2))) AS varchar(20)) AS [154]
,cast(sum(cast(A.[155] AS numeric(18,2))) AS varchar(20)) AS [155]
,cast(sum(cast(A.[156] AS numeric(18,2))) AS varchar(20)) AS [156]
,cast(sum(cast(A.[157] AS numeric(18,2))) AS varchar(20)) AS [157]
,cast(sum(cast(A.[158] AS numeric(18,2))) AS varchar(20)) AS [158]
,cast(sum(cast(A.[159] AS numeric(18,2))) AS varchar(20)) AS [159]
,cast(sum(cast(A.[160] AS numeric(18,2))) AS varchar(20)) AS [160]
,cast(sum(cast(A.[161] AS numeric(18,2))) AS varchar(20)) AS [161]
,cast(sum(cast(A.[162] AS numeric(18,2))) AS varchar(20)) AS [162]
,cast(sum(cast(A.[163] AS numeric(18,2))) AS varchar(20)) AS [163]
,cast(sum(cast(A.[164] AS numeric(18,2))) AS varchar(20)) AS [164]
,cast(sum(cast(A.[165] AS numeric(18,2))) AS varchar(20)) AS [165]
,cast(sum(cast(A.[166] AS numeric(18,2))) AS varchar(20)) AS [166]
,cast(sum(cast(A.[167] AS numeric(18,2))) AS varchar(20)) AS [167]
,cast(sum(cast(A.[168] AS numeric(18,2))) AS varchar(20)) AS [168]
,cast(sum(cast(A.[169] AS numeric(18,2))) AS varchar(20)) AS [169]
,cast(sum(cast(A.[170] AS numeric(18,2))) AS varchar(20)) AS [170]
,cast(sum(cast(A.[171] AS numeric(18,2))) AS varchar(20)) AS [171]
,cast(sum(cast(A.[172] AS numeric(18,2))) AS varchar(20)) AS [172]
,cast(sum(cast(A.[173] AS numeric(18,2))) AS varchar(20)) AS [173]
,cast(sum(cast(A.[174] AS numeric(18,2))) AS varchar(20)) AS [174]
,cast(sum(cast(A.[175] AS numeric(18,2))) AS varchar(20)) AS [175]
,cast(sum(cast(A.[176] AS numeric(18,2))) AS varchar(20)) AS [176]
,cast(sum(cast(A.[177] AS numeric(18,2))) AS varchar(20)) AS [177]
,cast(sum(cast(A.[178] AS numeric(18,2))) AS varchar(20)) AS [178]
,cast(sum(cast(A.[179] AS numeric(18,2))) AS varchar(20)) AS [179]
,cast(sum(cast(A.[180] AS numeric(18,2))) AS varchar(20)) AS [180]
,cast(sum(cast(A.[181] AS numeric(18,2))) AS varchar(20)) AS [181]
,cast(sum(cast(A.[182] AS numeric(18,2))) AS varchar(20)) AS [182]
,cast(sum(cast(A.[183] AS numeric(18,2))) AS varchar(20)) AS [183]
,cast(sum(cast(A.[184] AS numeric(18,2))) AS varchar(20)) AS [184]
,cast(sum(cast(A.[185] AS numeric(18,2))) AS varchar(20)) AS [185]
,cast(sum(cast(A.[186] AS numeric(18,2))) AS varchar(20)) AS [186]
,cast(sum(cast(A.[187] AS numeric(18,2))) AS varchar(20)) AS [187]
,cast(sum(cast(A.[188] AS numeric(18,2))) AS varchar(20)) AS [188]
,cast(sum(cast(A.[189] AS numeric(18,2))) AS varchar(20)) AS [189]
,cast(sum(cast(A.[190] AS numeric(18,2))) AS varchar(20)) AS [190]
,cast(sum(cast(A.[191] AS numeric(18,2))) AS varchar(20)) AS [191]
,cast(sum(cast(A.[192] AS numeric(18,2))) AS varchar(20)) AS [192]
,cast(sum(cast(A.[193] AS numeric(18,2))) AS varchar(20)) AS [193]
,cast(sum(cast(A.[194] AS numeric(18,2))) AS varchar(20)) AS [194]
,cast(sum(cast(A.[195] AS numeric(18,2))) AS varchar(20)) AS [195]
,cast(sum(cast(A.[196] AS numeric(18,2))) AS varchar(20)) AS [196]
,cast(sum(cast(A.[197] AS numeric(18,2))) AS varchar(20)) AS [197]
,cast(sum(cast(A.[198] AS numeric(18,2))) AS varchar(20)) AS [198]
,cast(sum(cast(A.[199] AS numeric(18,2))) AS varchar(20)) AS [199]
,cast(sum(cast(A.[200] AS numeric(18,2))) AS varchar(20)) AS [200]


 FROM 
(SELECT 
  ROW_NUMBER() OVER(ORDER BY IdplanillaCabecera ASC) 
  AS RowId,       rn.[1], 
       rn.[2], 
       rn.[3], 
       rn.[4], 
       rn.[5], 
       rn.[6], 
       rn.[7], 
       rn.[8], 
       rn.[9], 
       rn.[10], 
       rn.[11], 
       rn.[12], 
       rn.[13], 
       rn.[14], 
       rn.[15], 
       rn.[16], 
       rn.[17], 
       rn.[18], 
       rn.[19], 
       rn.[20], 
       rn.[21], 
       rn.[22], 
       rn.[23], 
       rn.[24], 
       rn.[25], 
       rn.[26], 
       rn.[27], 
       rn.[28], 
       rn.[29], 
       rn.[30], 
       rn.[31], 
       rn.[32], 
       rn.[33], 
       rn.[34], 
       rn.[35], 
       rn.[36], 
       rn.[37], 
       rn.[38], 
       rn.[39], 
       rn.[40], 
       rn.[41], 
       rn.[42], 
       rn.[43], 
       rn.[44], 
       rn.[45], 
       rn.[46], 
       rn.[47], 
       rn.[48], 
       rn.[49], 
       rn.[50], 
       rn.[51], 
       rn.[52], 
       rn.[53], 
       rn.[54], 
       rn.[55], 
       rn.[56], 
       rn.[57], 
       rn.[58], 
       rn.[59], 
       rn.[60], 
       rn.[61], 
       rn.[62], 
       rn.[63], 
       rn.[64], 
       rn.[65], 
       rn.[66], 
       rn.[67], 
       rn.[68], 
       rn.[69], 
       rn.[70], 
       rn.[71], 
       rn.[72], 
       rn.[73], 
       rn.[74], 
       rn.[75], 
       rn.[76], 
       rn.[77], 
       rn.[78], 
       rn.[79], 
       rn.[80], 
       rn.[81], 
       rn.[82], 
       rn.[83], 
       rn.[84], 
       rn.[85], 
       rn.[86], 
       rn.[87], 
       rn.[88], 
       rn.[89], 
       rn.[90], 
       rn.[91], 
       rn.[92], 
       rn.[93], 
       rn.[94], 
       rn.[95], 
       rn.[96], 
       rn.[97], 
       rn.[98], 
       rn.[99], 
       rn.[100], 
       rn.[101], 
       rn.[102], 
       rn.[103], 
       rn.[104], 
       rn.[105], 
       rn.[106], 
       rn.[107], 
       rn.[108], 
       rn.[109], 
       rn.[110], 
       rn.[111], 
       rn.[112], 
       rn.[113], 
       rn.[114], 
       rn.[115], 
       rn.[116], 
       rn.[117], 
       rn.[118], 
       rn.[119], 
       rn.[120], 
       rn.[121], 
       rn.[122], 
       rn.[123], 
       rn.[124], 
       rn.[125], 
       rn.[126], 
       rn.[127], 
       rn.[128], 
       rn.[129], 
       rn.[130], 
       rn.[131], 
       rn.[132], 
       rn.[133], 
       rn.[134], 
       rn.[135], 
       rn.[136], 
       rn.[137], 
       rn.[138], 
       rn.[139], 
       rn.[140], 
       rn.[141], 
       rn.[142], 
       rn.[143], 
       rn.[144], 
       rn.[145], 
       rn.[146], 
       rn.[147], 
       rn.[148], 
       rn.[149], 
       rn.[150], 
       rn.[151], 
       rn.[152], 
       rn.[153], 
       rn.[154], 
       rn.[155], 
       rn.[156], 
       rn.[157], 
       rn.[158], 
       rn.[159], 
       rn.[160], 
       rn.[161], 
       rn.[162], 
       rn.[163], 
       rn.[164], 
       rn.[165], 
       rn.[166], 
       rn.[167], 
       rn.[168], 
       rn.[169], 
       rn.[170], 
       rn.[171], 
       rn.[172], 
       rn.[173], 
       rn.[174], 
       rn.[175], 
       rn.[176], 
       rn.[177], 
       rn.[178], 
       rn.[179], 
       rn.[180], 
       rn.[181], 
       rn.[182], 
       rn.[183], 
       rn.[184], 
       rn.[185], 
       rn.[186], 
       rn.[187], 
       rn.[188], 
       rn.[189], 
       rn.[190], 
       rn.[191], 
       rn.[192], 
       rn.[193], 
       rn.[194], 
       rn.[195], 
       rn.[196], 
       rn.[197], 
       rn.[198], 
       rn.[199], 
       rn.[200]
FROM ERP.ReporteNomina rn) A WHERE A.RowId <>1
---------------------------------------------------------------------------------


SELECT rn.IdplanillaCabecera, 
       rn.Correlativo, 
       rn.TipoDocumento, 
       rn.NumeroDocumento, 
       rn.NombreEmpleado, 
       rn.RegimenPensionario, 
	   rn.CargoEmpleado, 
       rn.FechaIniDatoLaboral, 
       rn.FechaFinDatoLaboral, 
       rn.FechaCese, 
       rn.Sueldo, 
       rn.HoraBase, 
       rn.[1], 
       rn.[2], 
       rn.[3], 
       rn.[4], 
       rn.[5], 
       rn.[6], 
       rn.[7], 
       rn.[8], 
       rn.[9], 
       rn.[10], 
       rn.[11], 
       rn.[12], 
       rn.[13], 
       rn.[14], 
       rn.[15], 
       rn.[16], 
       rn.[17], 
       rn.[18], 
       rn.[19], 
       rn.[20], 
       rn.[21], 
       rn.[22], 
       rn.[23], 
       rn.[24], 
       rn.[25], 
       rn.[26], 
       rn.[27], 
       rn.[28], 
       rn.[29], 
       rn.[30], 
       rn.[31], 
       rn.[32], 
       rn.[33], 
       rn.[34], 
       rn.[35], 
       rn.[36], 
       rn.[37], 
       rn.[38], 
       rn.[39], 
       rn.[40], 
       rn.[41], 
       rn.[42], 
       rn.[43], 
       rn.[44], 
       rn.[45], 
       rn.[46], 
       rn.[47], 
       rn.[48], 
       rn.[49], 
       rn.[50], 
       rn.[51], 
       rn.[52], 
       rn.[53], 
       rn.[54], 
       rn.[55], 
       rn.[56], 
       rn.[57], 
       rn.[58], 
       rn.[59], 
       rn.[60], 
       rn.[61], 
       rn.[62], 
       rn.[63], 
       rn.[64], 
       rn.[65], 
       rn.[66], 
       rn.[67], 
       rn.[68], 
       rn.[69], 
       rn.[70], 
       rn.[71], 
       rn.[72], 
       rn.[73], 
       rn.[74], 
       rn.[75], 
       rn.[76], 
       rn.[77], 
       rn.[78], 
       rn.[79], 
       rn.[80], 
       rn.[81], 
       rn.[82], 
       rn.[83], 
       rn.[84], 
       rn.[85], 
       rn.[86], 
       rn.[87], 
       rn.[88], 
       rn.[89], 
       rn.[90], 
       rn.[91], 
       rn.[92], 
       rn.[93], 
       rn.[94], 
       rn.[95], 
       rn.[96], 
       rn.[97], 
       rn.[98], 
       rn.[99], 
       rn.[100], 
       rn.[101], 
       rn.[102], 
       rn.[103], 
       rn.[104], 
       rn.[105], 
       rn.[106], 
       rn.[107], 
       rn.[108], 
       rn.[109], 
       rn.[110], 
       rn.[111], 
       rn.[112], 
       rn.[113], 
       rn.[114], 
       rn.[115], 
       rn.[116], 
       rn.[117], 
       rn.[118], 
       rn.[119], 
       rn.[120], 
       rn.[121], 
       rn.[122], 
       rn.[123], 
       rn.[124], 
       rn.[125], 
       rn.[126], 
       rn.[127], 
       rn.[128], 
       rn.[129], 
       rn.[130], 
       rn.[131], 
       rn.[132], 
       rn.[133], 
       rn.[134], 
       rn.[135], 
       rn.[136], 
       rn.[137], 
       rn.[138], 
       rn.[139], 
       rn.[140], 
       rn.[141], 
       rn.[142], 
       rn.[143], 
       rn.[144], 
       rn.[145], 
       rn.[146], 
       rn.[147], 
       rn.[148], 
       rn.[149], 
       rn.[150], 
       rn.[151], 
       rn.[152], 
       rn.[153], 
       rn.[154], 
       rn.[155], 
       rn.[156], 
       rn.[157], 
       rn.[158], 
       rn.[159], 
       rn.[160], 
       rn.[161], 
       rn.[162], 
       rn.[163], 
       rn.[164], 
       rn.[165], 
       rn.[166], 
       rn.[167], 
       rn.[168], 
       rn.[169], 
       rn.[170], 
       rn.[171], 
       rn.[172], 
       rn.[173], 
       rn.[174], 
       rn.[175], 
       rn.[176], 
       rn.[177], 
       rn.[178], 
       rn.[179], 
       rn.[180], 
       rn.[181], 
       rn.[182], 
       rn.[183], 
       rn.[184], 
       rn.[185], 
       rn.[186], 
       rn.[187], 
       rn.[188], 
       rn.[189], 
       rn.[190], 
       rn.[191], 
       rn.[192], 
       rn.[193], 
       rn.[194], 
       rn.[195], 
       rn.[196], 
       rn.[197], 
       rn.[198], 
       rn.[199], 
       rn.[200]
FROM ERP.ReporteNomina rn ORDER BY rn.NombreEmpleado ASC;
END