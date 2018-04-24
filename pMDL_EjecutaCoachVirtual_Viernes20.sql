sp_helptext pMDL_EjecutaCoachVirtual

Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE pMDL_EjecutaCoachVirtual
(
	@CodPais CHAR(2),
	@FlagLog INT = 0 
)
AS
BEGIN

SET NOCOUNT ON;
SET ANSI_WARNINGS OFF;
SET DEADLOCK_PRIORITY NORMAL;


declare @CodPais CHAR(2) = 'PE'
declare @FlagLog INT = 1

declare @AnioCampana char(6),
	    @AnioCampana_Expo char(6)
				
	/* Set Default Value logs  */ 
	declare @m_time datetime,  
	  @item int,
	  @DesPais VARCHAR(20)
	     
	set @m_time  = GETDATE()  
	set @item = 1  
		
/* Asignamos el AnioCampana a Procesar */
SELECT @AnioCampana = MAX(AnioCampana) FROM DWH_ANALITICO.dbo.DWH_FVTAPROEBECAM WHERE CodPais = @CodPais

/*Calculamos el AnioCampana a Exponer*/
SET @AnioCampana_Expo = dbo.CalculaAnioCampana(@Aniocampana,2)

/*Asignamos Descripcion del Pais*/
SELECT @DesPais = Despais FROM BD_ANALITICO.dbo.DPAIS WHERE CodPais = @CodPais

		/* Inicio de Proceso */
	if (@FlagLog = 1) print 'Inicio de Proceso: ' + cast(@item as varchar) + ' - ' + convert(varchar, @m_time, 103) + ' ' + convert(varchar, @m_time, 108) + ' :dd:' + CAST(datediff(SS, @m_time, GETDATE()) AS VARCHAR)  
	select @m_time  = GETDATE(), @item = @item+1  

	IF NOT EXISTS (SELECT * FROM DWH_DSTATUSFACTURACION WHERE AnioCampana = @AnioCampana AND CodPais = @CodPais AND FlagStatusFactSC = 1 )
	BEGIN
		--Actualizando Campañas en base a que campaña tiene al menos 1 region cerrada.
		SET @AnioCampana = dbo.CalculaAnioCampana(@AnioCampana, -1)
		SET @AnioCampana_Expo = dbo.CalculaAnioCampana(@AnioCampana, 2)
	END
	
	declare @TAnioCampana TAnioCampanaType
	INSERT INTO @TAnioCampana VALUES (@AnioCampana,NULL,NULL,NULL,NULL,NULL,NULL,NULL) 

	declare @AnioCampana_5  char(6),
			@AnioCampana_6  char(6),
			@AnioCampana_1  char(6),
			@AnioCampana_2  char(6),
			@AnioCampana_c1 CHAR(6),
			@AnioCampana_Recencia char(6),
			@Porcentaje_Nivel1_Categoria real,
			@Porcentaje_Nivel11_Categoria real,
			@Porcentaje_Nivel2_Categoria real,
			@Porcentaje_Nivel1_Marca real,
			@Porcentaje_Nivel2_Marca real,
			@Val1  real,
			@Val2  real,
			@Val3  real,
			@Val4  real,
			@Val5  real,
			@Val6  real,
			@Val7  real,
			@Val8  real,
			@Val9  real,
			@Val10 real,
			@Val11 real,
			@Val12 real,
			@Val13 real

	SET @AnioCampana_5 = dbo.CalculaAnioCampana(@AnioCampana, -4)
	SET @AnioCampana_6 = dbo.CalculaAnioCampana(@AnioCampana, -5)
	SET @AnioCampana_2 = dbo.CalculaAnioCampana(@AnioCampana, -2)
	SET @AnioCampana_1 = dbo.CalculaAnioCampana(@AnioCampana, -1)
	SET @AnioCampana_Recencia = dbo.CalculaAnioCampana(@AnioCampana, -12)
	SET @AnioCampana_c1		= dbo.CalculaAnioCampana(@AnioCampana,1)
	
	/*Obteniendo Parametros de Scores*/
	SELECT @Porcentaje_Nivel1_Categoria = Sentido*Peso FROM BD_ANALITICO.dbo.MDL_VirtualCoach_Scores WHERE CodPais = @CodPais AND Variables = 'Pc_Nivel1_Categoria'
	SELECT @Porcentaje_Nivel11_Categoria = Sentido*Peso FROM BD_ANALITICO.dbo.MDL_VirtualCoach_Scores WHERE CodPais = @CodPais AND Variables = 'Pc_Nivel2_Categoria'
	SELECT @Porcentaje_Nivel2_Categoria = Sentido*Peso FROM BD_ANALITICO.dbo.MDL_VirtualCoach_Scores WHERE CodPais = @CodPais AND Variables = 'Pc_Nivel3_Categoria'
	SELECT @Porcentaje_Nivel1_Marca = Sentido*Peso FROM BD_ANALITICO.dbo.MDL_VirtualCoach_Scores WHERE CodPais = @CodPais AND Variables = 'Pc_Nivel1_Marca'
	SELECT @Porcentaje_Nivel2_Marca = Sentido*Peso FROM BD_ANALITICO.dbo.MDL_VirtualCoach_Scores WHERE CodPais = @CodPais AND Variables = 'Pc_Nivel2_Marca'

	SELECT @Val1 = Sentido*Peso FROM BD_ANALITICO.dbo.MDL_VirtualCoach_Scores WHERE CodPais = @CodPais AND Variables = 'ProbTopU6C'
	SELECT @Val2 = Sentido*Peso FROM BD_ANALITICO.dbo.MDL_VirtualCoach_Scores WHERE CodPais = @CodPais AND Variables = 'IndPorcTop'
	SELECT @Val3 = Sentido*Peso FROM BD_ANALITICO.dbo.MDL_VirtualCoach_Scores WHERE CodPais = @CodPais AND Variables = 'ScoreTop_p0'
	SELECT @Val4 = Sentido*Peso FROM BD_ANALITICO.dbo.MDL_VirtualCoach_Scores WHERE CodPais = @CodPais AND Variables = 'ProbLanzU6C'
	SELECT @Val5 = Sentido*Peso FROM BD_ANALITICO.dbo.MDL_VirtualCoach_Scores WHERE CodPais = @CodPais AND Variables = 'IndPorcLanz'
	SELECT @Val6 = Sentido*Peso FROM BD_ANALITICO.dbo.MDL_VirtualCoach_Scores WHERE CodPais = @CodPais AND Variables = 'Venta_Est_Lanz'
	SELECT @Val7 = Sentido*Peso FROM BD_ANALITICO.dbo.MDL_VirtualCoach_Scores WHERE CodPais = @CodPais AND Variables = 'ScoreLanzamiento_p0'
	SELECT @Val8 = Sentido*Peso FROM BD_ANALITICO.dbo.MDL_VirtualCoach_Scores WHERE CodPais = @CodPais AND Variables = 'Pc_ScoreMarca'
	SELECT @Val9 = Sentido*Peso FROM BD_ANALITICO.dbo.MDL_VirtualCoach_Scores WHERE CodPais = @CodPais AND Variables = 'PseudoScoreMarca'
	SELECT @Val10 = Sentido*Peso FROM BD_ANALITICO.dbo.MDL_VirtualCoach_Scores WHERE CodPais = @CodPais AND Variables = 'ScoreMarca_p0'
	SELECT @Val11 = Sentido*Peso FROM BD_ANALITICO.dbo.MDL_VirtualCoach_Scores WHERE CodPais = @CodPais AND Variables = 'Pc_ScoreCategoria'
	SELECT @Val12 = Sentido*Peso FROM BD_ANALITICO.dbo.MDL_VirtualCoach_Scores WHERE CodPais = @CodPais AND Variables = 'PseudoScoreCategoria'
	SELECT @Val13 = Sentido*Peso FROM BD_ANALITICO.dbo.MDL_VirtualCoach_Scores WHERE CodPais = @CodPais AND Variables = 'ScoreCategoria_p0'
	
	UPDATE @TAnioCampana
	SET AnioCampanaExpo = @AnioCampana_Expo ,
		AnioCampana_1 = @AnioCampana_1,
		AnioCampana_2 = @AnioCampana_2,
		Aniocampana_5 = @AnioCampana_5,
		AnioCampana_6 = @AnioCampana_6,
		AnioCampana_Recencia = @AnioCampana_Recencia
	WHERE AnioCampana = @AnioCampana
	
	if (@FlagLog = 1) print 'Crea Temp. Consultoras: ' + cast(@item as varchar) + ' - ' + convert(varchar, @m_time, 103) + ' ' + convert(varchar, @m_time, 108) + ' :dd:' + CAST(datediff(SS, @m_time, GETDATE()) AS VARCHAR)  
	select @m_time  = GETDATE(), @item = @item+1  
		
	IF OBJECT_ID('tempdb..#Consultoras_Activas') IS NOT NULL DROP TABLE #Consultoras_Activas
	SELECT CodPais,PKEbelista
	INTO #Consultoras_Activas
	FROM DWH_ANALITICO.dbo.DWH_FSTAEBECAM A 
	WHERE AnioCampana BETWEEN @AnioCampana_1 AND @AnioCampana AND CodPais = @CodPais
	AND FlagActiva = 1 AND CodComportamientoRolling in (1,2,3,4,5,6,7)
	GROUP BY CodPais,PkEbelista

	/* CONSULTORAS CON LAS QUE SE VA A TRABAJAR*/
	if OBJECT_ID ('tempdb..#Consultoras')is not null drop table #Consultoras
	select 
		a.CodPais, 
		d.Aniocampana, 
		d.AnioCampanaExpo,
		d.AnioCampana_1,
		d.AnioCampana_2,
		d.AnioCampana_5,
		d.AnioCampana_6,
		d.AnioCampana_Recencia,
		a.PKEbelista,
		b.CodEbelista, 
		c.CodRegion,
		c.CodZona, 
		a.CodComportamientoRolling,
		e.DesnivelComportamiento,
		b.AnioCampanaIngreso,
		CAST(NULL as INT) as EdadBelcorp,
		datediff(yy, b.FechaNacimiento, getdate()) as Edad,
		0 as NroCamComproOfertaDigital,
		cast(0.0 as decimal(9,2)) as Porc_RevistaU6C,
		FlagPasoPedido,
		a.Constancia,
		CAST(0 as INT) as FlagTP1,
		CAST(0 as INT) as FlagTP2
	into #Consultoras
	from DWH_ANALITICO.dbo.DWH_FSTAEBECAM a with (nolock)
	inner join DWH_ANALITICO.dbo.DWH_DEBELISTA b with (nolock) on a.pkebelista = b.pkebelista AND a.CodPais = B.CodPais
	inner join DWH_ANALITICO.dbo.DWH_DGEOGRAFIACAMPANA c with (nolock) on a.AnioCampana = c.AnioCampana and a.PkTerritorio = c.PkTerritorio AND A.CodPais = C.CodPais
	left join DWH_ANALITICO.dbo.DWH_DCOMPORTAMIENTOROLLING e with (nolock) on e.codcomportamiento = a.codcomportamientorolling
	inner join @TAnioCampana d on D.AnioCampana = A.AnioCampana 
	inner join #Consultoras_Activas f on f.PkEbelista = a.PkEbelista and a.CodPais = f.CodPais
	where a.CodComportamientoRolling in (1,2,3,4,5,6,7) and A.CodPais = @CodPais
	AND c.CodRegion in (SELECT CodRegion FROM dbo.DWH_DSTATUSFACTURACION WHERE CodPais = @CodPais AND AnioCampana in (SELECT AnioCampana FROM @TAnioCampana) and FlagStatusFactSC = 1) 
	
	CREATE INDEX idx_consultoras ON #Consultoras(CodPais,AnioCampana,AnioCampanaExpo,Pkebelista,CodEbelista);
	
	UPDATE #Consultoras SET EdadBelcorp = dbo.DiffAnioCampanas(AnioCampana,AnioCampanaIngreso)/18 

	
	;With ConsultorasPalancas as 
	(
		select b.AnioCampana,a.CodPais,a.PKEbelista, 
			count(distinct a.AnioCampana) as NroCamComproOfertaDigital
		from dbo.DWH_FSTAEBECAM a with (nolock)
		inner join #Consultoras b on a.PKEbelista = b.PKEbelista and A.CodPais = B.CodPais
		where a.AnioCampana between @AnioCampana_6 and @AnioCampana and A.CodPais = @CodPais and (FlagCompraOPT+FlagcompraODD+FlagCompraOF+FlagCompraOF) > 0
		group by b.AnioCampana,a.CodPais,a.PKEbelista
	)
	update a
	set a.NroCamComproOfertaDigital = b.NroCamComproOfertaDigital
	from #Consultoras a 
	inner join ConsultorasPalancas b on a.PKEbelista = b.PKEbelista and a.AnioCampana = B.AnioCampana AND A.CodPais = B.CodPais


	if OBJECT_ID ('tempdb..#PedidosWEB_IPUNICO')is not null drop table #PedidosWEB_IPUNICO

	;With PedidosWEBIPUNICO as
	(
		select b.AnioCampana,a.CodPais,a.PKEbelista, 
			count(case when a.codigofacturainternet in ('WEB','WMX','APP','APM','APW') then a.AnioCampana end) NroPedidoWeb,
			count(case when a.FlagIpUnicoZona  = 1 then a.AnioCampana end) NroPedidoIPUnico,
			count(*) NroPedidos
		from dbo.DWH_FSTAEBECAM a with (nolock)
		inner join #Consultoras b with (nolock) on a.PKEbelista = b.PKEbelista and A.CodPais = B.CodPais
		where a.AnioCampana between B.AnioCampana_6 and B.Aniocampana and a.FlagPasoPedido = 1 --***
		group by b.AnioCampana,a.CodPais,a.PKEbelista
	), UltimasXCamRecencia as
	(
		select b.AnioCampana,a.CodPais,a.PKEbelista, 
			max(a.AnioCampana) as UltCampWeb
		from dbo.DWH_FSTAEBECAM a with (nolock)
		inner join #Consultoras b on a.PKEbelista = b.PKEbelista and A.CodPais = B.CodPais
		where a.AnioCampana between B.AnioCampana_Recencia and B.Aniocampana and a.FlagPasoPedido = 1 --***
		and a.codigofacturainternet in ('WEB','WMX','APP','APM','APW')
		group by b.AnioCampana,a.CodPais,a.PKEbelista
	)
	select b.AnioCampana,a.CodPais,a.PKEbelista, 
		isnull(UltCampWeb,B.AnioCampana_Recencia) as UltCampWeb, 
		NroPedidos, 
		NroPedidoWeb, 
		NroPedidoIPUnico,
		cast(NroPedidoWeb/(cast(NroPedidos as Real)) as decimal(9,2)) as Porc_PedidosWebU6C,
		cast(NroPedidoIPUnico/(cast(NroPedidos as Real)) as decimal(9,2)) as Porc_PedidosIPUnicoU6C,
		cast(NroCamComproOfertaDigital/(cast(NroPedidos as Real)) as decimal(9,2)) as Porc_PedidosOfertaDigitalU6C
	into #PedidosWEB_IPUNICO
	from PedidosWEBIPUNICO a 
	inner join #Consultoras b on a.PKEbelista = b.PKEbelista and a.AnioCampana = b.AnioCampana and A.CodPais = B.CodPais
	left join UltimasXCamRecencia c on a.PKEbelista = c.PKEbelista and a.Aniocampana = c.AnioCampana AND A.CodPais = C.CodPais

	CREATE INDEX idx_PedidosWeb ON #PedidosWEB_IPUNICO(AnioCampana,Pkebelista);

		/* VENTA DE LAS CONSULTORAS CON LAS QUE SE VA A TRABAJAR, A NIVEL CONSULTORA, PRODUCTO */
	if (@FlagLog = 1) print 'Crea Temp. FVTAPROEBECAM: ' + cast(@item as varchar) + ' - ' + convert(varchar, @m_time, 103) + ' ' + convert(varchar, @m_time, 108) + ' :dd:' + CAST(datediff(SS, @m_time, GETDATE()) AS VARCHAR)  
	select @m_time  = GETDATE(), @item = @item+1  

	if OBJECT_ID('tempdb..#FVTAPROEBECAM') is not null drop table #FVTAPROEBECAM

	SELECT A.*
	INTO #FVTAPROEBECAM
	FROM DWH_FVTAPROEBECAM a
	WHERE A.AnioCampana BETWEEN @AnioCampana_6 AND @AnioCampana AND A.CodPais = @CodPais
	AND A.AnioCampana = A.AnioCampanaRef 

	CREATE INDEX idx_tmp_fvtaproebecam ON #FVTAPROEBECAM(AnioCampana, CodPais, PkProducto,PkTipoOferta, CodVenta )

	if (@FlagLog = 1) print 'Crea Temp. FVTAPROEBE : ' + cast(@item as varchar) + ' - ' + convert(varchar, @m_time, 103) + ' ' + convert(varchar, @m_time, 108) + ' :dd:' + CAST(datediff(SS, @m_time, GETDATE()) AS VARCHAR)  
	select @m_time  = GETDATE(), @item = @item+1  


	if OBJECT_ID ('tempdb..#FVTAPROEBE')is not null drop table #FVTAPROEBE

	Select a.CodPais,
		a.AnioCampana,
		c.Aniocampana as AnioCampanaConsultora,
		c.AnioCampana_6,
		c.AnioCampanaExpo, 
		c.PkEbelista, c.CodRegion,
		a.PKProducto, b.CodCUC, b.desproductoCUC, 
		a.RealTCPromedio,
		a.EStTCPromedio,
		b.CodMarca, b.DesUnidadNegocio,  m.DesCatalogo, 
		case when b.DesCategoria = 'CUIDADO PERSONAL' then 'CP'
			when b.DesCategoria = 'FRAGANCIAS' then 'FG'
			when b.DesCategoria = 'MAQUILLAJE' then 'MQ'
			when b.DesCategoria = 'TRATAMIENTO CORPORAL' then 'TC'
			when b.DesCategoria = 'TRATAMIENTO FACIAL' then 'TF' end CodCategoria,
		max(a.Descuento) as Descuento,
		sum(a.RealUUVendidas) as RealUUVendidas,
		sum(a.RealVtaMnNeto) as RealVtaMnNeto
	INTO #FVTAPROEBE 
	from  #FVTAPROEBECAM A with (nolock) 	
	CROSS APPLY(SELECT TOP 1 * FROM #Consultoras C with (nolock) WHERE a.PKEbelista = c.PKEbelista and A.CodPais = C.CodPais) C 
	CROSS APPLY(SELECT TOP 1 * FROM DWH_DProducto b with (nolock) WHERE a.PkProducto = b.PkProducto and A.CodPais = b.CodPais) b
	CROSS APPLY(SELECT TOP 1 * FROM DWH_dtipooferta d with (nolock) WHERE a.CodCanalVenta = d.CodCanalVenta and a.PkTipoOferta = d.PkTipoOferta and A.CodPais = D.CodPais) d 
	CROSS APPLY(SELECT TOP 1 * FROM DWH_DMatrizCampana m with (nolock)
		WHERE a.CodCanalVenta = m.CodCanalVenta and a.AnioCampana = m.AnioCampana 
		and a.PkProducto =m.PkProducto and a.PKTipoOferta = m.PKTipoOferta and a.CodVenta  = m.CodVenta  and A.CodPais = m.CodPais) m
	where --a.AnioCampana = a.AnioCampanaRef and 
	d.CodTipoProfit = '01' and a.AnioCampana between @AnioCampana_6 and @AnioCampana --***
	and b.CodMarca in ('A','B','C') and A.CodPais = @CodPais
	and b.DesCategoria in ('FRAGANCIAS','CUIDADO PERSONAL','MAQUILLAJE','TRATAMIENTO FACIAL', 'TRATAMIENTO CORPORAL')
	group by a.CodPais,a.AnioCampana,c.AnioCampana,c.AnioCampana_6, c.AnioCampanaExpo, c.PkEbelista, c.CodRegion, a.PKProducto, b.CodCUC, b.desproductoCUC,
			a.RealTCPromedio,a.EStTCPromedio,--CASE WHEN C.AnioCampana = A.AnioCampana THEN ISNULL(a.EstTCPromedio,1) ELSE a.RealTCPromedio END, 
			b.CodMarca, b.DesUnidadNegocio,  m.DesCatalogo, 
			case when b.DesCategoria = 'CUIDADO PERSONAL' then 'CP'
			when b.DesCategoria = 'FRAGANCIAS' then 'FG'
			when b.DesCategoria = 'MAQUILLAJE' then 'MQ'
			when b.DesCategoria = 'TRATAMIENTO CORPORAL' then 'TC'
			when b.DesCategoria = 'TRATAMIENTO FACIAL' then 'TF' end
	having sum(a.RealVtaMNNeto)>0 

	CREATE INDEX idx_PedidosWeb ON #FVTAPROEBE(CodPais,AnioCampana,Pkebelista);


/*Utiliza el TC Estimado para la campaña que sigue abierta */

	UPDATE #FVTAPROEBE
	SET RealTCPromedio = EstTCPromedio
	WHERE RealTCPromedio = 1
	

	/*Actualizando Porc_RevistaU6C*/

	;With DistribucionRevista as
	(
		select CodPais,AnioCampanaConsultora,PkEbelista, 
			SUM(case when DesCatalogo like '%REVISTA%' then RealUUVendidas  else 0 End)  as RealUUVendidasRevista,
			SUM(RealUUVendidas)*1.0  as RealUUVendidas
		from #FVTAPROEBE 
		group by CodPais,AnioCampanaConsultora,PkEbelista
	)
	update a
	set a.Porc_RevistaU6C = case when b.RealUUVendidas = 0 then 0 else isnull(b.RealUUVendidasRevista,0)/(b.RealUUVendidas*1.0)  end
	from #Consultoras a
	inner join DistribucionRevista b on a.PKEbelista = b.PKEbelista and a.AnioCampana = b.AnioCampanaConsultora and a.CodPais = b.CodPais --***
	
	/*RECONOCIMIENTOS */
	if (@FlagLog = 1) print 'Crea Temp. Reconocimientos: ' + cast(@item as varchar) + ' - ' + convert(varchar, @m_time, 103) + ' ' + convert(varchar, @m_time, 108) + ' :dd:' + CAST(datediff(SS, @m_time, GETDATE()) AS VARCHAR)  
	select @m_time  = GETDATE(), @item = @item+1  
	
	/* MAX VENTA DE LAS CONSULTORAS LAS ULTIMAS 6 CAMPAÑAS */
	if OBJECT_ID ('tempdb..#Reconocimiento')is not null drop table #Reconocimiento
	;With MaxRealVta as 
	(
		select b.AnioCampana,b.PkEbelista, max(ISNULL(a.RealVtaMNFactura,0)) as MaxRealVtaMNFactura
		from dbo.DWH_DNROFACTURA a
		right join #Consultoras b on a.pkebelista = b.pkebelista and A.CodPais = B.CodPais
		where a.AnioCampana between @AnioCampana_5 and @AnioCampana and CodTipoDocumento = 'N' AND A.FlagOrdenAnulado = 0 --***
		group by b.AnioCampana,b.PkEbelista
	), PrimeraCompraOnline as 
	(
		select B.AnioCampana,a.CodPais,a.PkEbelista, 
			count(a.AnioCampana ) as ComproOnlineU6C
		from dbo.DWH_FSTAEBECAM a
		inner join #Consultoras b on a.pkebelista = b.pkebelista and A.CodPais = B.CodPais
		where a.AnioCampana between @AnioCampana_6 and @AnioCampana 
		and a.FlagPasoPedido= 1 AND a.FlagIpUnicoZona = 1 and a.CodPais = @CodPais
		group by B.AnioCampana,a.CodPais,a.PkEbelista

	),CompraPlan20PU5C as 
	(
		SELECT B.AnioCampana, A.PkEbelista,COUNT(A.AnioCampana) as OfertaDigitalPU5C
		FROM dbo.DWH_FSTAEBECAM A 
		INNER JOIN #Consultoras B ON A.Pkebelista = B.PKEbelista and A.CodPais = B.CodPais
		WHERE A.AnioCampana BETWEEN @AnioCampana_5 AND @AnioCampana AND A.CodPais = @CodPais
			AND (A.FlagCompraOPT + A.FlagCompraODD + A.FlagCompraOF + A.FlagCompraFDC + A.FlagCompraSR) > 0
		GROUP BY B.AnioCampana, A.PkEbelista
	)
	select 
		a.AnioCampana,
		a.PkEbelista, 
		a.MaxRealVtaMNFactura,
		ISNULL(b.ComproOnlineU6C,0) as ComproOnlineU6C,
		CAST(0 as INT) AS MaxDescuento,
		ISNULL(e.OfertaDigitalPU5C,0) as OfertaDigitalPU5C
	into #Reconocimiento
	from MaxRealVta a
	left join PrimeraCompraOnline b on a.PkEbelista = b.PkEbelista and a.Aniocampana = b.AnioCampana 
	left join CompraPlan20PU5C e on e.AnioCampana = a.AnioCampana and e.PKEbelista = a.PKEbelista
	group by a.AnioCampana,
		a.PkEbelista, 
		a.MaxRealVtaMNFactura,
		ISNULL(b.ComproOnlineU6C,0),
		ISNULL(e.OfertaDigitalPU5C,0)


	/* VENTA DE LAS CONSULTORAS CON LAS QUE SE VA A TRABAJAR, A NIVEL CONSULTORA, PRODUCTO, PSP */

	if OBJECT_ID ('tempdb..#FVTAPROEBE1')is not null drop table #FVTAPROEBE1

	select a.CodPais,
		c.AnioCampana as AnioCampanaConsultora,
		a.AnioCampana,
		c.AnioCampana_2,
		c.AnioCampanaExpo,
		c.PkEbelista, 
		a.RealTCPromedio,
		a.EStTCPromedio,
		max(a.Descuento) as Descuento,
		sum(a.RealUUVendidas) as RealUUVendidas,
		sum(a.RealVtaMnNeto) as RealVtaMnNeto
	INTO #FVTAPROEBE1
	from dbo.DWH_FVTAPROEBECAM a with (nolock)
	right join #Consultoras c with (nolock) on a.PKEbelista = c.PKEbelista and A.CodPais = C.CodPais
	inner join dbo.DWH_DPRODUCTO b with (nolock) on a.PkProducto = b.PkProducto AND a.CodPais = b.CodPais
	inner join dbo.DWH_DTIPOOFERTA d with (nolock) on a.PkTipoOferta = d.PkTipoOferta AND A.CodPais = D.CodPais
	where a.AnioCampana = a.AnioCampanaRef and d.CodTipoProfit = '01' and a.AnioCampana between c.AnioCampana_5 and c.Aniocampana AND A.CodPais = @CodPais
	group by a.CodPais,c.AnioCampana,a.AnioCampana,c.AnioCampana_2,c.AnioCampanaExpo, c.PkEbelista,
			a.RealTCPromedio,a.EStTCPromedio--CASE WHEN C.AnioCampana = A.AnioCampana THEN ISNULL(a.EstTCPromedio,1) ELSE a.RealTCPromedio END
	having sum(a.RealUUVendidas)>0

	CREATE INDEX idx_fvtsproebe1 ON #FVTAPROEBE1(CodPais,AnioCampana,PkEbelista);
		
	if (@FlagLog = 1) print 'Crea Temp. Consultora Pedido: ' + cast(@item as varchar) + ' - ' + convert(varchar, @m_time, 103) + ' ' + convert(varchar, @m_time, 108) + ' :dd:' + CAST(datediff(SS, @m_time, GETDATE()) AS VARCHAR)  
	select @m_time  = GETDATE(), @item = @item+1  

	if OBJECT_ID ('tempdb..#TempConsultoraPedido')is not null drop table #TempConsultoraPedido

	select CodPais,PKEbelista,AnioCampanaConsultora,AnioCampana_6, count(distinct AnioCampana) as NroPedidos
	into #TempConsultoraPedido
	from #FVTAPROEBE 
	group by CodPais,PKEbelista,AnioCampanaConsultora,AnioCampana_6
		
	CREATE INDEX idx_ConsultoraPedido ON #TempConsultoraPedido(PkEbelista,AnioCampanaConsultora);

	/* PUP Por Marca */
	
	if (@FlagLog = 1) print 'Crea Temp. Marca: ' + cast(@item as varchar) + ' - ' + convert(varchar, @m_time, 103) + ' ' + convert(varchar, @m_time, 108) + ' :dd:' + CAST(datediff(SS, @m_time, GETDATE()) AS VARCHAR)  
	select @m_time  = GETDATE(), @item = @item+1  

	if OBJECT_ID ('tempdb..#TmpMarca')is not null drop table #TmpMarca
	;With TempConsultoraMarca as
	(
		select a.AnioCampanaconsultora as Aniocampana,a.PKEbelista, a.CodMarca, 
		sum(a.RealUUVendidas)/(cast(b.NroPedidos as real)) as PUP,
		row_number() over (partition by a.AnioCampanaConsultora,a.PKEbelista order by sum(a.RealUUVendidas) desc) as Orden
		from #FVTAPROEBE a
		inner join #TempConsultoraPedido b on a.PKEbelista = b.PKEbelista and a.AnioCampanaConsultora = b.AnioCampanaConsultora --and A.CodPais = B.CodPais
		group by a.AnioCampanaconsultora,a.PKEbelista, a.CodMarca, b.NroPedidos
	), PorMarca as
	(
		SELECT 
			AnioCampana,
			PKEbelista, 
			isnull([A],0) as PUP_Lbel,
			isnull([B],0) as PUP_Esika,
			isnull([C],0) as PUP_Cyzone,
			isnull([A],0)+isnull([B],0)+isnull([C],0) as PUP_Marca
		FROM (select Aniocampana,PKEbelista, CodMarca, PUP from TempConsultoraMarca) AS SourceTable
		PIVOT
		(
		AVG([PUP])
		FOR CodMarca IN ([A],[B],[C])
		) AS PivotTable
	), RankMarca as
	(
		SELECT 
			AnioCampana,
			PKEbelista, 
			isnull([A],0) as Rank_Lbel,
			isnull([B],0) as Rank_Esika,
			isnull([C],0) as Rank_Cyzone
		FROM (
			select 
				AnioCampana,
				PKEbelista, 
				CodMarca, 
				case Orden when 1 then 3
				when 2 then 2
				when 3 then 1
				else 0 end Orden
				from TempConsultoraMarca) AS SourceTable
		PIVOT
		(
		MAX([Orden])
		FOR CodMarca IN ([A],[B],[C])
		) AS PivotTable
	)
	select a.*, b.Rank_Lbel, b.Rank_Esika, b.Rank_Cyzone 
	into #TmpMarca 
	from PorMarca a
	inner join RankMarca b on a.PKEbelista = b.PKEbelista and a.AnioCampana = b.AnioCampana

	/* PUP Por Categoria*/
	if (@FlagLog = 1) print 'Crea Temp. Categoria: ' + cast(@item as varchar) + ' - ' + convert(varchar, @m_time, 103) + ' ' + convert(varchar, @m_time, 108) + ' :dd:' + CAST(datediff(SS, @m_time, GETDATE()) AS VARCHAR)  
	select @m_time  = GETDATE(), @item = @item+1  

	if OBJECT_ID ('tempdb..#TmpCategoria') is not null drop table #TmpCategoria
	;With TempConsultoraCategoria as
	(
		select a.AnioCampanaConsultora as AnioCampana,a.PKEbelista, a.CodCategoria, 
			sum(a.RealUUVendidas)/(cast(b.NroPedidos as real)) as PUP,
			row_number() over (partition by a.AnioCampanaConsultora, a.PKEbelista order by sum(a.RealUUVendidas) desc) as Orden
		from #FVTAPROEBE a
		inner join #TempConsultoraPedido b on a.PKEbelista = b.PKEbelista AND A.AnioCampanaConsultora = B.AnioCampanaConsultora
		group by a.AnioCampanaConsultora,a.PKEbelista, a.CodCategoria, b.NroPedidos
	), PorCategoria as
	(
		SELECT 
			AnioCampana,
			PKEbelista, 
			isnull([CP],0) as PUP_CP,
			isnull([FG],0) as PUP_FG,
			isnull([MQ],0) as PUP_MQ,
			isnull([TC],0) as PUP_TC,
			isnull([TF],0) as PUP_TF,
			isnull([CP],0) +isnull([FG],0) +isnull([MQ],0) +isnull([TC],0) + isnull([TF],0) as PUP_Categoria
		FROM (select AnioCampana,PKEbelista, CodCategoria, PUP from TempConsultoraCategoria) AS SourceTable
		PIVOT
		(
		AVG([PUP])
		FOR CodCategoria IN ([CP],[FG],[MQ],[TF],[TC])
		) AS PivotTable
	), RankCategoria as
	(
		SELECT 
			AnioCampana,
			PKEbelista, 
			isnull([CP],0) as Rank_CP,
			isnull([FG],0) as Rank_FG,
			isnull([MQ],0) as Rank_MQ,
			isnull([TC],0) as Rank_TC,
			isnull([TF],0) as Rank_TF
		FROM (select AnioCampana,PKEbelista, CodCategoria, 
			case Orden when 1 then 5
				when 2 then 4
				when 3 then 3
				when 4 then 2
				when 5 then 1
				else 0 end Orden
		from TempConsultoraCategoria) AS SourceTable
		PIVOT
		(
		AVG([Orden])
		FOR CodCategoria IN ([CP],[FG],[MQ],[TF],[TC])
		) AS PivotTable
	) 
	select a.* ,
		b.Rank_CP, 
		b.Rank_FG, 
		b.Rank_MQ, 
		b.Rank_TC, 
		b.Rank_TF	
	into #TmpCategoria
	from PorCategoria  a
	inner join RankCategoria b on a.PKEbelista = b.PKEbelista and a.AnioCampana = b.AnioCampana
	
	/* NroLanzamientos */
	if (@FlagLog = 1) print 'Crea Temp. Lanzamientos: ' + cast(@item as varchar) + ' - ' + convert(varchar, @m_time, 103) + ' ' + convert(varchar, @m_time, 108) + ' :dd:' + CAST(datediff(SS, @m_time, GETDATE()) AS VARCHAR)  
	select @m_time  = GETDATE(), @item = @item+1  
		
	DECLARE @AnioCampanaLanz_5 CHAR(6)
	SET @AnioCampanaLanz_5 = dbo.CalculaAnioCampana(@AnioCampana,-5)

	if OBJECT_ID ('tempdb..#Lanzamientos') is not null Drop table #Lanzamientos
	Select *
	into #Lanzamientos
	from BD_ANALITICO.dbo.ARMSG_Lanz_Top
	where Descripcion='Lanzamientos'
	and AnioCampanaExpo BETWEEN @AnioCampana_5 AND @AnioCampana_Expo 
	and codpais= @CodPais
	and FlagUso=1
	
	CREATE INDEX idx_Lanzamientos ON #Lanzamientos(CodPais, AnioCampanaExpo, CodCUC);

	/* Pedidos por Consultoras en las 6UC */
	if (@FlagLog = 1) print 'Crea Temp. PedidoLanzamiento: ' + cast(@item as varchar) + ' - ' + convert(varchar, @m_time, 103) + ' ' + convert(varchar, @m_time, 108) + ' :dd:' + CAST(datediff(SS, @m_time, GETDATE()) AS VARCHAR)  
	select @m_time  = GETDATE(), @item = @item+1  
	
	if OBJECT_ID ('tempdb..#TempConsultoraPedidoLanzamiento') is not null drop table #TempConsultoraPedidoLanzamiento

	;With TempConsultoraPedidoLanzamiento as
	(
		select a.CodPais,a.AnioCampanaConsultora ,a.PKEbelista, count(distinct a.AnioCampana) as NroPedidosconLanzamientos
		from #FVTAPROEBE a
		inner join #Lanzamientos b on a.AnioCampana = b.AnioCampanaExpo and a.CodPais = b.CodPais
		group by a.CodPais,a.AnioCampanaConsultora ,a.PKEbelista 
		
	), CompraLanzamientos as
	(
		select a.CodPais,AnioCampanaConsultora,PKEbelista, count(distinct a.AnioCampana) as NroPedidosComproLanzamientos
		from #FVTAPROEBE a
		inner join #Lanzamientos b on a.AnioCampana = b.AnioCampanaExpo and a.CodCUC = b.CodCUC and a.CodPais = b.CodPais
		group by a.CodPais,AnioCampanaConsultora,PKEbelista 
	)
	select a.AnioCampanaConsultora,a.PKEbelista, 
		isnull(b.NroPedidosComproLanzamientos,0) as NroPedidosComproLanzamientos, 
		a.NroPedidosconLanzamientos,
		isnull(b.NroPedidosComproLanzamientos,0)/(cast(a.NroPedidosconLanzamientos as real)) as PropensionLanzamiento
	into #TempConsultoraPedidoLanzamiento
	from TempConsultoraPedidoLanzamiento a
	left join CompraLanzamientos  b on a.PKEbelista = b.PKEbelista and a.CodPais = b.CodPais and  a.AnioCampanaconsultora = b.AnioCampanaConsultora --***

	/****************************/

	
	/* NroLanzamientos Marca / Categoria */
	if (@FlagLog = 1) print 'Crea Temp. TempResultados: ' + cast(@item as varchar) + ' - ' + convert(varchar, @m_time, 103) + ' ' + convert(varchar, @m_time, 108) + ' :dd:' + CAST(datediff(SS, @m_time, GETDATE()) AS VARCHAR)  
	select @m_time  = GETDATE(), @item = @item+1  
		
	if OBJECT_ID ('tempdb..#TempResultado') is not null drop table #TempResultado

	;With LanzamientoMarca as
	(
		SELECT 
			AnioCampanaConsultora,PKEbelista, 
			isnull([A],0) as NroLanzamientos_Lbel,
			isnull([B],0) as NroLanzamientos_Esika,
			isnull([C],0) as NroLanzamientos_Cyzone
		FROM (select AnioCampanaConsultora,a.PKEbelista, a.CodMarca, count(distinct a.AnioCampana) as NroPedidosLanzamientos
				from #FVTAPROEBE a
				inner join #Lanzamientos b on a.AnioCampana = b.AnioCampanaExpo and a.CodCUC = b.CodCUC
				group by AnioCampanaConsultora,a.PKEbelista, a.CodMarca) AS SourceTable
		PIVOT
		(
		AVG([NroPedidosLanzamientos])
		FOR CodMarca IN ([A],[B],[C])
		) AS PivotTable
	), LanzamientoCategoria as
	(
		SELECT 
			AnioCampanaConsultora,PKEbelista, 
			isnull([CP],0) as NroLanzamientos_CP,
			isnull([FG],0) as NroLanzamientos_FG,
			isnull([MQ],0) as NroLanzamientos_MQ,
			isnull([TC],0) as NroLanzamientos_TC,
			isnull([TF],0) as NroLanzamientos_TF
		FROM (select AnioCampanaConsultora,a.PKEbelista, a.CodCategoria, count(distinct a.AnioCampana) as NroPedidosLanzamientos
				from #FVTAPROEBE a
				inner join #Lanzamientos b on a.AnioCampana = b.AnioCampanaExpo and a.CodCUC = b.CodCUC 
				group by AnioCampanaConsultora,a.PKEbelista, a.CodCategoria) AS SourceTable
		PIVOT
		(
		AVG([NroPedidosLanzamientos])
		FOR CodCategoria IN ([CP],[FG],[MQ],[TF],[TC])
		) AS PivotTable
		
	)
	select a.CodPais, 
		a.AnioCampana,
		a.AnioCampanaExpo,
		a.PKEbelista, a.CodEbelista, 
		a.CodRegion, a.CodZona, a.CodComportamientoRolling, 
		a.Edad,
		d.Porc_PedidosWebU6C, 
		d.Porc_PedidosIPUnicoU6C, 
		d.Porc_PedidosOfertaDigitalU6C,
		dbo.DiffAnioCampanas(a.Aniocampana,d.UltCampWeb) as RecenciaPedidoWebU6C, 
		a.Porc_RevistaU6C,
		la.NroPedidosconLanzamientos, 
		la.NroPedidosComproLanzamientos, 
		la.PropensionLanzamiento,
		case when b.PUP_Marca  = 0 then 0 else b.PUP_Lbel/b.PUP_Marca End as Porc_PUP_Lbel, 
		case when b.PUP_Marca  = 0 then 0 else b.PUP_Esika/b.PUP_Marca End as Porc_PUP_Esika, 
		case when b.PUP_Marca  = 0 then 0 else b.PUP_Cyzone/b.PUP_Marca End as Porc_PUP_Cyzone, 
		case when c.PUP_Categoria  = 0 then 0 else c.PUP_CP/c.PUP_Categoria End as Porc_PUP_CP, 
		case when c.PUP_Categoria  = 0 then 0 else c.PUP_FG/c.PUP_Categoria End as Porc_PUP_FG, 
		case when c.PUP_Categoria  = 0 then 0 else c.PUP_MQ/c.PUP_Categoria End as Porc_PUP_MQ, 
		case when c.PUP_Categoria  = 0 then 0 else c.PUP_TC/c.PUP_Categoria End as Porc_PUP_TC,
		case when c.PUP_Categoria  = 0 then 0 else c.PUP_TF/c.PUP_Categoria End as Porc_PUP_TF, 
		case when la.NroPedidosconLanzamientos = 0 then 0 else isnull(dM.NroLanzamientos_Lbel,0)/la.NroPedidosconLanzamientos end as PropLanzamientos_Lbel,
		case when la.NroPedidosconLanzamientos = 0 then 0 else isnull(dM.NroLanzamientos_Esika,0)/la.NroPedidosconLanzamientos end as PropLanzamientos_Esika,
		case when la.NroPedidosconLanzamientos = 0 then 0 else isnull(dM.NroLanzamientos_Cyzone,0)/la.NroPedidosconLanzamientos end as PropLanzamientos_Cyzone,
		case when la.NroPedidosconLanzamientos = 0 then 0 else isnull(dC.NroLanzamientos_CP,0)/la.NroPedidosconLanzamientos end as PropLanzamientos_CP,
		case when la.NroPedidosconLanzamientos = 0 then 0 else isnull(dC.NroLanzamientos_FG,0)/la.NroPedidosconLanzamientos end as PropLanzamientos_FG,
		case when la.NroPedidosconLanzamientos = 0 then 0 else isnull(dC.NroLanzamientos_MQ,0)/la.NroPedidosconLanzamientos end as PropLanzamientos_MQ,
		case when la.NroPedidosconLanzamientos = 0 then 0 else isnull(dC.NroLanzamientos_TC,0)/la.NroPedidosconLanzamientos end as PropLanzamientos_TC,
		case when la.NroPedidosconLanzamientos = 0 then 0 else isnull(dC.NroLanzamientos_TF,0)/la.NroPedidosconLanzamientos end as PropLanzamientos_TF,
		b.Rank_Lbel, b.Rank_Esika, b.Rank_Cyzone,
		c.Rank_CP, c.Rank_FG, c.Rank_MQ, c.Rank_TC, c.Rank_TF
	into #TempResultado
	from #Consultoras a
	left join #TmpMarca b on a.PKEbelista = b.PKEbelista and a.AnioCampana = b.AnioCampana
	left join #TmpCategoria c on a.PKEbelista = c.PKEbelista and a.AnioCampana = c.AnioCampana
	left join #PedidosWEB_IPUNICO d on a.PKEbelista = d.PKEbelista and a.AnioCampana = d.AnioCampana
	left join #TempConsultoraPedidoLanzamiento la on a.PKEbelista = la.PKEbelista and a.AnioCampana = la.AnioCampanaConsultora
	left join LanzamientoMarca dM on a.PKEbelista = dM.PKEbelista and a.AnioCampana = dM.AnioCampanaConsultora
	left join LanzamientoCategoria dC on a.PKEbelista = dC.PKEbelista and a.AnioCampana = dC.AnioCampanaConsultora
	
		
	if OBJECT_ID ('tempdb..#ncamp') is not null drop table #ncamp

	select IDENTITY(int,1,1) as NCAMP, AnioCampana 
	into #ncamp
	from DWH_FVTAPROEBECAM A WHERE a.AnioCampana between @AnioCampana_5 and @AnioCampana_c1 and CodPais = @CodPais
	group by AnioCampana
	order by AnioCampana
	
	--2miin 
	IF OBJECT_ID('tempdb..#TempEbelistaCamp') IS NOT NULL DROP TABLE #TempEbelistaCamp

	;With PivotUnidades as 
	(
		SELECT 
			AnioCampanaConsultora,
			PKEbelista, 
			isnull([1],0) as UUCampXmenos5,
			isnull([2],0) as UUCampXmenos4,
			isnull([3],0) as UUCampXmenos3,
			isnull([4],0) as UUCampXmenos2,
			isnull([5],0) as UUCampXmenos1,
			isnull([6],0) as UUCampXmenos0
		FROM (	select AnioCampanaConsultora,a.PKEbelista, b.NCAMP, sum(RealUUVendidas) as RealUUVendidas
				from #FVTAPROEBE1 a
				inner join #ncamp b on a.AnioCampana = b.AnioCampana
				group by AnioCampanaConsultora,a.PKEbelista, b.NCAMP 
		) AS SourceTable
		PIVOT
		(
		AVG([RealUUVendidas])
		FOR NCAMP IN ([1],[2],[3],[4],[5],[6])
		) AS PivotTable
	), PivotVenta as 
	(
		SELECT 
			AnioCampanaConsultora,
			PKEbelista, 
			isnull([1],0) as VtaCampXmenos5,
			isnull([2],0) as VtaCampXmenos4,
			isnull([3],0) as VtaCampXmenos3,
			isnull([4],0) as VtaCampXmenos2,
			isnull([5],0) as VtaCampXmenos1,
			isnull([6],0) as VtaCampXmenos0
		FROM (	select AnioCampanaConsultora,a.PKEbelista, b.NCAMP, cast(sum(RealVtaMNNeto/RealTCPromedio) as Real) as RealVtaDolNeto
				from #FVTAPROEBE1 a
				inner join #ncamp b on a.AnioCampana = b.AnioCampana
				group by AnioCampanaConsultora,a.PKEbelista, b.NCAMP
		) AS SourceTable
		PIVOT
		(
		AVG([RealVtaDolNeto])
		FOR NCAMP IN ([1],[2],[3],[4],[5],[6])
		) AS PivotTable
	)
	select a.AnioCampanaConsultora,a.PKEbelista,
		a.UUCampXmenos0, a.UUCampXmenos1, a.UUCampXmenos2, a.UUCampXmenos3, a.UUCampXmenos4, a.UUCampXmenos5, 
		b.VtaCampXmenos0, b.VtaCampXmenos1, b.VtaCampXmenos2, b.VtaCampXmenos3, b.VtaCampXmenos4, b.VtaCampXmenos5
	into #TempEbelistaCamp
	from PivotUnidades a
	inner join PivotVenta b on a.PKEbelista = b.PKEbelista and a.AnioCampanaConsultora = b.AnioCampanaConsultora

	
	if OBJECT_ID ('tempdb..#NumLogueos') is not null Drop table #NumLogueos
	SELECT AnioCampanaConsultora,b.PkEbelista, b.NroPedidos, COUNT(a.IpOrigen) AS NumLogueosU6C 
	into #NumLogueos
	FROM DWH_ANALITICO.dbo.DWH_FLOGINGRESOPORTAL a 
	inner join #TempConsultoraPedido b on a.PKEbelista=b.pkebelista and a.CodPais = b.CodPais
	WHERE AnioCampanaWeb BETWEEN B.AnioCampana_6 and B.AnioCampanaConsultora AND a.CodPais = @CodPais
	GROUP BY AnioCampanaConsultora,b.PkEbelista, b.NroPedidos

	/* PUP/PSP por Ultimas 3 y 6 Campañas */
	if OBJECT_ID ('tempdb..#TempEbelistaUXC ') is not null drop table #TempEbelistaUXC 
	;With ConsultoraPorCampana as 
	(
		select AnioCampanaConsultora,PKEbelista, 
			Aniocampana, AnioCampana_2,
			max(Descuento) as Descuento,
			sum(RealUUVendidas) as RealUUVendidas,
			sum(RealVtaMNNeto/RealTCPromedio) as RealVtaDolNeto
		from #FVTAPROEBE1
		group by AnioCampanaConsultora,PKEbelista, Aniocampana,AnioCampana_2
	), ConsultoraU6C as 
	(
		select AnioCampanaConsultora,PKEbelista, 
			sum(RealUUVendidas)/ cast(count(AnioCampana)  as real) as PUPU6C,
			sum(RealVtaDolNeto)/ cast(count(AnioCampana)  as real) as PSPU6C,
			max(RealVtaDolNeto) as MaxRealVtaDolNetoU6C,
			max(Descuento) as DescuentoU6C
		from ConsultoraPorCampana
		group by AnioCampanaConsultora,PKEbelista 
	), ConsultoraU3C as 
	(
		select AnioCampanaConsultora,PKEbelista, 
			sum(RealUUVendidas)/ cast(count(AnioCampana)  as real) as PUPU3C,
			sum(RealVtaDolNeto)/ cast(count(AnioCampana)  as real) as PSPU3C
		from ConsultoraPorCampana
		where AnioCampana>= AnioCampana_2
		group by AnioCampanaConsultora,PKEbelista
	)
	select a.AnioCampanaConsultora,a.PKEbelista, a.PUPU6C, a.PSPU6C, a.MaxRealVtaDolNetoU6C, a.DescuentoU6C, 
		isnull(b.PUPU3C,0) as PUPU3C, isnull(b.PSPU3C,0) as PSPU3C, convert(float,0) as NroLogueos
	into #TempEbelistaUXC 
	from ConsultoraU6C a
	left join ConsultoraU3C b on a.pkebelista = b.pkebelista and a.AnioCampanaConsultora = b.AnioCampanaConsultora 

	Update #TempEbelistaUXC
	Set NroLogueos= a.NumLogueosU6C/(a.NroPedidos*1.0)
	from #NumLogueos a
	inner join #TempEbelistaUXC b on a.pkebelista=b.pkebelista and a.AnioCampanaConsultora = b.AnioCampanaConsultora

	/* RESULTADO POR CONSULTORA */
	if OBJECT_ID ('tempdb..#ResultadoFinal') is not null drop table #ResultadoFinal

	select a.CodPais, a.AnioCampana,a.AnioCampanaExpo, a.Pkebelista, a.CodEbelista, a.CodRegion, a.CodZona, a.CodComportamientoRolling, a.Edad, c.NroLogueos,
		a.Porc_PedidosWebU6C, a.Porc_PedidosIPUnicoU6C, a.Porc_PedidosOfertaDigitalU6C,
		a.RecenciaPedidoWebU6C, a.Porc_RevistaU6C,
		d.MaxRealVtaMNFactura, d.MaxDescuento, d.ComproOnlineU6C,d.OfertaDigitalPU5C,
		a.NroPedidosconLanzamientos, a.NroPedidosComproLanzamientos, a.PropensionLanzamiento,
		a.Porc_PUP_Lbel, a.Porc_PUP_Esika, a.Porc_PUP_Cyzone, 
		a.Porc_PUP_CP, a.Porc_PUP_FG, a.Porc_PUP_MQ, a.Porc_PUP_TC, a.Porc_PUP_TF, 
		case 
			when Porc_PUP_Lbel>=Porc_PUP_Esika and Porc_PUP_Lbel>=Porc_PUP_Cyzone then 'A'
			when Porc_PUP_Esika>=Porc_PUP_Lbel and Porc_PUP_Esika>=Porc_PUP_Cyzone then 'B'
			else 'C' end as CodMarcaAfin,
		case
			when Porc_PUP_CP>=Porc_PUP_FG and Porc_PUP_CP>=Porc_PUP_MQ  and Porc_PUP_CP>=Porc_PUP_TC and Porc_PUP_CP>=Porc_PUP_TF then 'CP'
			when Porc_PUP_FG>=Porc_PUP_CP and Porc_PUP_FG>=Porc_PUP_MQ and Porc_PUP_FG>=Porc_PUP_TC and Porc_PUP_FG>=Porc_PUP_TF then 'FG'
			when Porc_PUP_MQ>=Porc_PUP_CP and Porc_PUP_MQ>=Porc_PUP_FG and Porc_PUP_MQ>=Porc_PUP_TC and Porc_PUP_MQ>=Porc_PUP_TF then 'MQ'
			when Porc_PUP_TC>=Porc_PUP_CP and Porc_PUP_TC>=Porc_PUP_FG and Porc_PUP_TC>=Porc_PUP_MQ and Porc_PUP_TC>=Porc_PUP_TF then 'TC'
			else 'TF' end as CodCategoriaAfin,
		a.PropLanzamientos_Lbel, a.PropLanzamientos_Esika, a.PropLanzamientos_Cyzone, 
		a.PropLanzamientos_CP, a.PropLanzamientos_FG, a.PropLanzamientos_MQ, a.PropLanzamientos_TC, a.PropLanzamientos_TF, 
		b.UUCampXmenos0, b.UUCampXmenos1, b.UUCampXmenos2, b.UUCampXmenos3, b.UUCampXmenos4, b.UUCampXmenos5, 
		b.VtaCampXmenos0, b.VtaCampXmenos1, b.VtaCampXmenos2, b.VtaCampXmenos3, b.VtaCampXmenos4, b.VtaCampXmenos5,
		c.PUPU6C, c.PSPU6C, c.MaxRealVtaDolNetoU6C, c.DescuentoU6C, c.PUPU3C, c.PSPU3C
	into #ResultadoFinal
	from #TempResultado a
	left join #TempEbelistaCamp b on a.PKEbelista = b.PKEbelista and a.AnioCampana = b.AnioCampanaConsultora
	left join #TempEbelistaUXC c on a.PKEbelista = c.PKEbelista and a.AnioCampana = c.AnioCampanaConsultora
	left join #Reconocimiento d on a.PKEbelista = d.PKEbelista and a.AnioCampana = d.AnioCampana
	
	/* RESULTADO LANZAMIENTOS */
	if (@FlagLog = 1) print 'Crea Temp. ResultadoLanzamiento: ' + cast(@item as varchar) + ' - ' + convert(varchar, @m_time, 103) + ' ' + convert(varchar, @m_time, 108) + ' :dd:' + CAST(datediff(SS, @m_time, GETDATE()) AS VARCHAR)  
	select @m_time  = GETDATE(), @item = @item+1  
 
	if OBJECT_ID ('tempdb..#MensajeLanzamientos') is not null drop table #MensajeLanzamientos
	-- Cambio b.aniocampana por a.aniocampana 

	; With SenoraLanzamiento as
	(
		select distinct a.CodPais, a.AnioCampana,a.PkEbelista,  a.CodEbelista, a.CodComportamientoRolling,
		b.CodVenta,b.CodCUC, b.DesproductoCUC, b.CodMarca, b.DesMarca, b.CodCategoria , b.DesCategoria,  
			a.NroPedidosconLanzamientos, a.NroPedidosComproLanzamientos, a.PropensionLanzamiento, b.Venta_Est_Neta,
			a.Rank_Lbel, a.Rank_Esika, a.Rank_Cyzone, a.Rank_CP, a.Rank_FG, a.Rank_MQ, a.Rank_TC, a.Rank_TF,
			case b.CodMarca when  'A' then a.Rank_Lbel 
				when  'B' then a.Rank_Esika
				when  'C' then a.Rank_Cyzone Else 0 End +
			case b.CodCategoria when  'CP' then a.Rank_CP 
				when  'FG' then a.Rank_FG
				when  'MQ' then a.Rank_MQ 
				when  'TC' then a.Rank_TC 
				when  'TF' then a.Rank_TF Else 0 End as RankScore,
			case b.CodMarca when  'A' then a.Porc_PUP_Lbel
				when  'B' then a.Porc_PUP_Esika
				when  'C' then a.Porc_PUP_Cyzone Else 0 End +
			case b.CodCategoria when  'CP' then 2*a.Porc_PUP_CP
				when  'FG' then 2*a.Porc_PUP_FG
				when  'MQ' then 2*a.Porc_PUP_MQ
				when  'TC' then 2*a.Porc_PUP_TC
				when  'TF' then 2*a.Porc_PUP_TF Else 0 End as PorcScore
		from #TempResultado a, #Lanzamientos b
		where b.AnioCampanaExpo = a.AnioCampanaExpo and a.CodPais = b.CodPais
		and FlagUso=1
	), LanzLanz as
	(
	  Select *,
	  Row_number() OVER  (PARTITION BY AnioCampana,PkEbelista ORDER BY PorcScore DESC) RankScoreLanz
	  from SenoraLanzamiento
	) 
	 Select *
	 into #MensajeLanzamientos
	 from LanzLanz 
	 where RankScoreLanz=1
	 order by PkEbelista

	  	  
	/* RESULTADO CATEGORIA */
	if OBJECT_ID ('tempdb..#PorcentajeCategoria') is not null drop table #PorcentajeCategoria

	;With TempConsultoraCategoria as
	(
		select a.AnioCampanaConsultora as AnioCampana, a.PKEbelista, a.CodCategoria, 
			sum(a.RealUUVendidas)/(cast(b.NroPedidos as real)) as PUP,
			row_number() over (partition by a.AnioCampanaConsultora, a.PKEbelista order by sum(a.RealUUVendidas) desc) as Orden
		from #FVTAPROEBE a
		inner join #TempConsultoraPedido b on a.PKEbelista = b.PKEbelista and a.aniocampanaconsultora = b.AnioCampanaConsultora
		group by a.AnioCampanaConsultora,a.PKEbelista, a.CodCategoria, b.NroPedidos
	), PorcentajeCategoria as 
	(
		select Aniocampana,PKEbelista, CodCategoria, Orden, 
			case when sum(PUP) over (partition by Pkebelista) = 0 then 0 Else
			PUP/(sum(PUP) over (partition by Pkebelista)) End as Por_PUP
		from TempConsultoraCategoria
	)
	select * 
	into #PorcentajeCategoria
	from PorcentajeCategoria


	-- #PorcentajeCategoria
	if OBJECT_ID ('tempdb..#ResultadoCategoria') is not null drop table #ResultadoCategoria


	--DECLARE @Porcentaje_Nivel1_Categoria real,
	--		@Porcentaje_Nivel11_Categoria real,
	--		@Porcentaje_Nivel2_Categoria real,
	--		@Porcentaje_Nivel1_Marca real,
	--		@Porcentaje_Nivel2_Marca real

	--SET @Porcentaje_Nivel1_Categoria = 0.6
	--SET @Porcentaje_Nivel11_Categoria = 0.25
	--SET @Porcentaje_Nivel2_Categoria = 0.8
	--SET @Porcentaje_Nivel1_Marca = 0.65
	--SET @Porcentaje_Nivel2_Marca = 0.90



	;with EbelistaIN as 
	(
		select AnioCampana, PKEbelista from #PorcentajeCategoria 
		where Orden = 1 and Por_PUP > @Porcentaje_Nivel1_Categoria
	
	), EbelistaOUT as 
	(
		select AnioCampana, PKEbelista from #PorcentajeCategoria 
		where Orden = 2 and Por_PUP > @Porcentaje_Nivel11_Categoria
	)
	SELECT a.AnioCampana,a.Pkebelista,CodCategoria, CodCategoria as CodCategoria_F, 5 as Score 
	into #ResultadoCategoria
	from #PorcentajeCategoria a 
	inner join EbelistaIN b on a.AnioCampana = b.AnioCampana and a.PKEbelista = b.PKEbelista
	left join EbelistaOUT c on a.AnioCampana = c.AnioCampana and a.Pkebelista = c.PKEbelista 
	where a.Orden = 2 and c.PkEbelista is null

	

	;with EbelistaIN as 
	(
		select AnioCampana, PKEbelista from #PorcentajeCategoria 
		where Orden = 1 and Por_PUP > @Porcentaje_Nivel1_Categoria
	
	), EbelistaOUT as 
	(
		select AnioCampana, PKEbelista from #PorcentajeCategoria 
		where Orden = 2 and Por_PUP <= @Porcentaje_Nivel11_Categoria
	)
	insert into #ResultadoCategoria
	Select a.AnioCampana, a.Pkebelista, CodCategoria, CodCategoria as CodCategoria_F, 4 as Score
	from #PorcentajeCategoria a 
	inner join EbelistaIN b on a.AnioCampana = b.AnioCampana and a.Pkebelista = b.PkEbelista
	left join EbelistaOUT c on a.AnioCampana = c.AnioCampana and a.PkEbelista = c.PkEbelista
	where a.Orden = 3 and c.Pkebelista is null
	
		;with EbelistaIN as 
		(
			select a.AnioCampana, a.PKEbelista from #PorcentajeCategoria a
			left join (select AnioCampana, PKEbelista from #PorcentajeCategoria where Orden <= 2
						group by AnioCampana,PKEbelista having sum(Por_PUP) <= @Porcentaje_Nivel2_Categoria) b on a.AnioCampana = b.AnioCampana and a.PKEbelista = b.PKEbelista
			where Orden = 1 and Por_PUP <= @Porcentaje_Nivel1_Categoria and b.PKEbelista is null
	
		), EbelistaOUT as 
		(
			select AnioCampana,PKEbelista from #ResultadoCategoria
		)
		insert into #ResultadoCategoria
		select a.AnioCampana, a.PKEbelista, CodCategoria,CodCategoria as CodCategoria_F, 4 as Score
		from #PorcentajeCategoria a
		inner join EbelistaIN b on a.AnioCampana = b.AnioCampana and a.Pkebelista = b.PkEbelista
		left join EbelistaOut c on a.anioCampana = c.AnioCampana and a.Pkebelista = c.PkEbelista
		where Orden = 3 and c.PkEbelista is null
		
		;with EbelistaIN as 
		(
			select a.AnioCampana, a.PKEbelista from #PorcentajeCategoria a
			left join (select AnioCampana, PKEbelista from #PorcentajeCategoria where Orden <= 3 
						group by AnioCampana,PKEbelista having sum(Por_PUP) <= @Porcentaje_Nivel2_Categoria) b on a.AnioCampana = b.AnioCampana and a.PKEbelista = b.PKEbelista
			where Orden = 1 and Por_PUP <= @Porcentaje_Nivel1_Categoria and b.PKEbelista is null
	
		), EbelistaOUT as 
		(
			select AnioCampana,PKEbelista from #ResultadoCategoria
		)
		insert into #ResultadoCategoria
		select a.AnioCampana, a.PKEbelista, CodCategoria,CodCategoria as CodCategoria_F, 3 as Score
		from #PorcentajeCategoria a
		inner join EbelistaIN b on a.AnioCampana = b.AnioCampana and a.Pkebelista = b.PkEbelista
		left join EbelistaOut c on a.anioCampana = c.AnioCampana and a.Pkebelista = c.PkEbelista
		where Orden = 4 and c.PkEbelista is null 


		;with EbelistaIN as 
		(
			select a.AnioCampana, a.PKEbelista from #PorcentajeCategoria a
			left join (select AnioCampana, PKEbelista from #PorcentajeCategoria where Orden <= 4 
						group by AnioCampana,PKEbelista having sum(Por_PUP) <= @Porcentaje_Nivel2_Categoria) b on a.AnioCampana = b.AnioCampana and a.PKEbelista = b.PKEbelista
			where Orden = 1 and Por_PUP <= @Porcentaje_Nivel1_Categoria and b.PKEbelista is null
	
		), EbelistaOUT as 
		(
			select AnioCampana,PKEbelista from #ResultadoCategoria
		)
		insert into #ResultadoCategoria
		select a.AnioCampana, a.PKEbelista, CodCategoria,CodCategoria as CodCategoria_F, 2 as Score --4
		from #PorcentajeCategoria a
		inner join EbelistaIN b on a.AnioCampana = b.AnioCampana and a.Pkebelista = b.PkEbelista
		left join EbelistaOut c on a.anioCampana = c.AnioCampana and a.Pkebelista = c.PkEbelista
		where Orden = 5 and c.PkEbelista is null


	;with EbelistaIN as
	(
		select AnioCampana,PKEbelista  from #PorcentajeCategoria
		group by AnioCampana,PKEbelista having count(distinct CodCategoria)=1
	), EbelistaOUT as 
	(
		select AnioCampana,PKEbelista from #ResultadoCategoria
	)
		insert into #ResultadoCategoria
		select a.AnioCampana,a.PKEbelista, case when CodCategoria = 'FG' then 'MQ' else 'FG' End as CodCategoria, 
		case when CodCategoria = 'FG' then 'MQ' else 'FG' End as CodCategoria_F,
		6 as Score 
		from #PorcentajeCategoria a 
		inner join EbelistaIN b on a.AnioCampana = b.AnioCampana and a.Pkebelista= b.PkEbelista
		left join EbelistaOUT c on a.AnioCampana = c.AnioCampana and a.Pkebelista = c.Pkebelista
		where c.Pkebelista is null


	if OBJECT_ID ('tempdb..#ConsTempMH') is not null drop table #ConsTempMH

	Select AnioCampana,pkebelista  
	into #ConsTempMH
	from #ResultadoCategoria

	/*****CHECAR****/

	If OBJECT_ID('tempdb..#Z_ResultadoCategoria') is not null drop table #Z_ResultadoCategoria
	;with EbelistaOUT AS 
	( select AnioCampana,PKEbelista  from #ConsTempMH	
	),EbelistaOUT2 AS 
	( select AnioCampana,PkEbelista from #ResultadoCategoria
	),	PreCategoria_Z as
	(
		select a.AnioCampana,a.Pkebelista, CodCategoria as Categoria_F,
			ROW_NUMBER() over (Partition By a.AnioCampana, a.Pkebelista ORDER BY Orden desc) as Orden
		from #PorcentajeCategoria a 
		left join EbelistaOUT b on a.AnioCampana = b.AnioCampana and a.Pkebelista = b.PkEbelista
		left join EbelistaOUT2 c on a.AnioCampana = c.AnioCampana and a.PKEbelista = c.PKEbelista
		where b.Pkebelista is null and c.Pkebelista is null 
		group by a.AnioCampana,a.Pkebelista, CodCategoria,Orden
		
	)
	select AnioCampana,Pkebelista, 'Z' as Categoria, Categoria_F, 0 as Score 
	into #Z_ResultadoCategoria
	from PreCategoria_Z 
	where Orden = 1
	group by AnioCampana,Pkebelista,Categoria_F
	

	insert into #ResultadoCategoria
	Select * from #Z_ResultadoCategoria
	
	/* RESULTADO MARCA */

	if OBJECT_ID ('tempdb..#LOVMarca') is not null drop table #LOVMarca

	select 'A' as CodMarca
	into #LOVMarca
	union all  
	select 'B' as CodMarca
	union all  
	select 'C' as CodMarca


	if OBJECT_ID ('tempdb..#PorcentajeMarca') is not null drop table #PorcentajeMarca

	;With TempConsultoraMarca as
	(
		select 
			b.AnioCampanaConsultora as AnioCampana,
			a.PKEbelista, 
			a.CodMarca, 
			sum(a.RealUUVendidas)/(cast(NroPedidos as real)) as PUP,
			row_number() over (partition by b.AnioCampanaConsultora,a.PKEbelista order by sum(a.RealUUVendidas) desc) as Orden
		from #FVTAPROEBE a
		inner join #TempConsultoraPedido b on a.PKEbelista = b.PKEbelista and a.AnioCampanaConsultora = b.AnioCampanaConsultora
		group by b.AnioCampanaConsultora,a.PKEbelista, a.CodMarca, b.NroPedidos

	), CompletaDMarca1 as 
	(
		select AnioCampana,PKEbelista, CodMarca
		from #Consultoras,  #LOVMarca
	), CompletaDMarca2 as 
	(
		select 
			A.AnioCampana,a.PKEbelista, a.CodMarca, isnull(b.PUP,0.0) as PUP, isnull(Orden,3) as Orden
		from CompletaDMarca1 a
		left join TempConsultoraMarca b on a.PKEbelista = b.PKEbelista and a.CodMarca = b.CodMarca and A.AnioCampana = B.AnioCampana
	), PorcentajeMarca as 
	(
		select 
			AnioCampana,
			PKEbelista, 
			CodMarca, 
			Orden, 
			case when sum(PUP) over (partition by AnioCampana,Pkebelista) = 0 then 0 Else
			PUP/(sum(PUP) over (partition by AnioCampana,Pkebelista)) End as Por_PUP
		from CompletaDMarca2
	)
	select * 
	into #PorcentajeMarca
	from PorcentajeMarca

	update a
	set a.Orden = 2
	from #PorcentajeMarca a
	inner join ( select AnioCampana,pkebelista, min(CodMarca) as CodMarca 
			from #PorcentajeMarca where Orden= 3 and Por_PUP = 0
			group by AnioCampana,pkebelista having count(*)= 2) b on a.pkebelista = b.pkebelista and a.CodMarca = b.CodMarca and a.AnioCampana = b.AnioCampana

	if OBJECT_ID ('tempdb..#ResultadoMarca') is not null drop table #ResultadoMarca

	select 
		a.Aniocampana,
		a.PKEbelista, 
		CodMarca, 
		CodMarca as CodMarca_F,--checar MH
		4 as Score 
	into #ResultadoMarca
	from #PorcentajeMarca a
	inner join (select AnioCampana,PKEbelista from #PorcentajeMarca where Orden = 1 and Por_PUP > @Porcentaje_Nivel1_Marca) b on a.AnioCampana = b.AnioCampana and a.Pkebelista = b.PkEbelista
	left join (select AnioCampana,PKEbelista from #PorcentajeMarca where Orden <= 2 group by AnioCampana,pkebelista having sum(Por_PUP) > @Porcentaje_Nivel2_Marca) c on a.AnioCampana = c.AnioCampana and a.Pkebelista = c.PkEbelista
	where Orden = 2 and c.PkEbelista is null

	Insert into #ResultadoMarca
	select a.AnioCampana,a.PKEbelista, CodMarca, 
	CodMarca as CodMarca_F,--checar MH
	2 as Score 
	from #PorcentajeMarca a
	inner join (select AnioCampana,PKEbelista from #PorcentajeMarca where Orden = 1 and Por_PUP > @Porcentaje_Nivel1_Marca) b on 
				a.AnioCampana = b.AnioCampana and a.Pkebelista = b.Pkebelista 
	left join (select AnioCampana,PKEbelista from #PorcentajeMarca where Orden <= 2 group by AnioCampana,pkebelista having sum(Por_PUP) <= @Porcentaje_Nivel2_Marca) c on 
				a.AnioCampana = c.AnioCampana and a.Pkebelista = c.PkEbelista
	left join (select AnioCampana,PKEbelista from #ResultadoMarca) d on a.AnioCampana = d.AnioCampana and a.PKEbelista = d.Pkebelista
	where Orden = 3 and c.PkEbelista is null and d.Pkebelista is null
	
	Insert into #ResultadoMarca
	select A.AnioCampana,A.PKEbelista, CodMarca, 
	CodMarca as CodMarca_F,--checar MH
	2 as Score 
	from #PorcentajeMarca a 
	inner join (select AnioCampana,PKEbelista from #PorcentajeMarca where Orden = 1 and Por_PUP <= @Porcentaje_Nivel1_Marca) b on a.AnioCampana = b.AnioCampana and a.Pkebelista = b.PkEbelista
	left join (select AnioCampana,PKEbelista from #PorcentajeMarca where Orden <= 2 group by AnioCampana,pkebelista having sum(Por_PUP) <= @Porcentaje_Nivel2_Marca) c on a.AnioCampana = c.AnioCampana and a.Pkebelista = c.Pkebelista
	left join (select AnioCampana,PKEbelista from #ResultadoMarca) d on a.AnioCampana = d.AnioCampana and a.PkEbelista = d.PkEbelista
	where Orden = 3 and d.PkEbelista is null and c.Pkebelista is null

if OBJECT_ID('tempdb..#Z_ResultadoMarca') is not null drop table #Z_ResultadoMarca

;with Pre_Z as
	(
		select A.AnioCampana,A.PKEbelista, 
		CodMarca as CodMarca_F,--Nuevo checar MH
		0 as Score
		from #PorcentajeMarca a 
		inner join (select AnioCampana,PKEbelista from #PorcentajeMarca where Orden = 1 and Por_PUP <= @Porcentaje_Nivel1_Marca) b on a.AnioCampana = b.AnioCampana and a.Pkebelista = b.PkEbelista
		left join (select AnioCampana,PKEbelista from #PorcentajeMarca where Orden <= 2 group by AnioCampana,pkebelista having sum(Por_PUP) > @Porcentaje_Nivel2_Marca) c on a.AnioCampana = c.AnioCampana and a.PkEbelista = c.Pkebelista
		left join (select AnioCampana,PKEbelista from #ResultadoMarca) d on d.AnioCampana = a.AnioCampana and a.Pkebelista = d.PkEbelista
		where c.PkEbelista is null and d.PkEbelista is null
		group by A.AnioCampana,A.PKEbelista, CodMarca
		having max(Orden)=3 
	)
	select AnioCampana,PKEbelista,
	'Z' as CodMarca,
	CodMarca_F,
	Score
	into #Z_ResultadoMarca
	from Pre_Z

	Insert into #ResultadoMarca
	Select * from #Z_ResultadoMarca

	insert into #ResultadoMarca
	select A.AnioCampana,A.PKEbelista, case when CodMarca= 'B' then 'A' else 'B' End as CodMarca, 
	case when CodMarca= 'B' then 'A' else 'B' End as CodMarca_F,
	6 as Score 
	from #ResultadoMarca a 
	inner join (select AnioCampana,PKEbelista  from #PorcentajeMarca group by AnioCampana,PKEbelista having count(distinct CodMarca)=1 ) b on a.AnioCampana = b.AnioCampana and a.Pkebelista = b.Pkebelista


	/* RESULTADO LISTADOS TOP */

	if (@FlagLog = 1) print 'Crea Temp. ResultadoTop: ' + cast(@item as varchar) + ' - ' + convert(varchar, @m_time, 103) + ' ' + convert(varchar, @m_time, 108) + ' :dd:' + CAST(datediff(SS, @m_time, GETDATE()) AS VARCHAR)  
	select @m_time  = GETDATE(), @item = @item+1  


	if OBJECT_ID ('tempdb..#HistoriaTop') is not null Drop table #HistoriaTop

	Select *
	into #HistoriaTop
	from BD_ANALITICO.dbo.ARMSG_Lanz_Top
	where Descripcion='Tops_M_C'
	and AnioCampanaExpo in (select AnioCampanaExpo From @TAnioCampana) --***
	and codpais=@CodPais
	and FlagUso=1

	CREATE INDEX idx_historiaTop ON #HistoriaTop(AnioCampanaExpo, CodPais, CodCUC)

if OBJECT_ID ('tempdb..#TopTop') is not null drop table #TopTop
--igual que lanzamiento
; With SenoraTop as 
(
	select a.CodPais, a.AnioCampana, a.PkEbelista, a.CodEbelista,b.CodVenta, b.CodCUC, b.DesproductoCUC, b.DesMarca, b.CodCategoria, 
			a.Rank_Lbel, a.Rank_Esika, a.Rank_Cyzone, a.Rank_CP, a.Rank_FG, a.Rank_MQ, a.Rank_TC, a.Rank_TF,
		case b.CodMarca when  'A' then a.Rank_Lbel 
			when  'B' then a.Rank_Esika
			when  'C' then a.Rank_Cyzone Else 0 End +
		case b.CodCategoria when  'CP' then a.Rank_CP 
			when  'FG' then a.Rank_FG
			when  'MQ' then a.Rank_MQ 
			when  'TC' then a.Rank_TC 
			when  'TF' then a.Rank_TF Else 0 End as RankScore,
		case b.CodMarca when  'A' then a.Porc_PUP_Lbel
			when  'B' then a.Porc_PUP_Esika
			when  'C' then a.Porc_PUP_Cyzone Else 0 End +
		case b.CodCategoria when  'CP' then 2*a.Porc_PUP_CP
			when  'FG' then 2*a.Porc_PUP_FG
			when  'MQ' then 2*a.Porc_PUP_MQ
			when  'TC' then 2*a.Porc_PUP_TC
			when  'TF' then 2*a.Porc_PUP_TF Else 0 End as PorcScore
	from #TempResultado a, #HistoriaTop b 
	where b.AnioCampanaExpo = A.AnioCampanaExpo --***
	and a.CodPais = b.CodPais 
	and FlagUso=1
), TopTop as
(
	Select CodPais,AnioCampana,PkEbelista,CodEbelista,CodVenta,CodCUC, DesproductoCUC, DesMarca, CodCategoria,PorcScore,
	Row_number() OVER  (PARTITION BY AnioCampana,PkEbelista ORDER BY PorcScore DESC) RankScoreTop
	from SenoraTop
) 
  Select CodPais,AnioCampana,PkEbelista,CodEbelista,CodVenta,CodCUC, DesproductoCUC, DesMarca, CodCategoria,PorcScore, RankScoreTop
  into #TopTop
  from TopTop 
  where RankScoreTop=1
  order by PkEbelista

  
if OBJECT_ID ('tempdb..#ResultadoTop') is not null drop table #ResultadoTop
  
; With PreTop as
(
	Select 
			a.CodPais, 
			a.Aniocampana, 
			a.CodEbelista,	
			a.pkebelista, d.CodComportamientorolling,
			d.CodMarcaAfin, d.CodCategoriaAfin, 
			c.NroPedidos, 
			PUPU6C,
			count(distinct b.aniocampana) as NroAspeosTopsU6C,
			sum(isnull(b.RealUUVendidas,0))/(NroPedidos*1.0) as PUPTop, 
			count(distinct b.aniocampana)/(NroPedidos*1.0) as ProbTop,
			(sum( isnull(RealUUVendidas,0) )/(NroPedidos*1.0))/(PUPU6C*1.0) as Pc_PUPTop,
			sum( isnull(RealUUVendidas,0) ) as RealUUVendidas, 
			count(distinct b.aniocampana) as NroCompraTop
	from #TopTop a 
	left join #FVTAPROEBE b on a.PKEbelista=b.PKEbelista and a.CodCUC=b.CodCUC and a.AnioCampana = b.AnioCampanaConsultora
	inner join #TempConsultoraPedido c on a.PKEbelista=c.PKEbelista and a.AnioCampana = c.AnioCampanaConsultora
	inner join #ResultadoFinal d on c.PKEbelista=d.PKEbelista and a.AnioCampana = d.AnioCampana
	group by a.CodPais, a.Aniocampana, a.CodEbelista, d.CodMarcaAfin, d.CodCategoriaAfin, a.pkebelista,	c.NroPedidos, PUPU6C,d.CodComportamientorolling
)
	Select 	a.CodPais,	a.Aniocampana, a.CodEbelista, a.CodMarcaAfin, a.CodCategoriaAfin, a.pkebelista, a.PUPTop, a.PUPU6C, a.Pc_PUPTop, a.ProbTop,
	b.CodVenta,b.CodCUC, b.DesproductoCUC, b.DesMarca, b.CodCategoria,b.PorcScore,a.CodComportamientorolling
	into #ResultadoTop
	from PreTop a
	inner join #TopTop b on a.pkebelista=b.pkebelista and a.AnioCampana = b.AnioCampana


	--/* 1 Impulsar Marca */

	if OBJECT_ID ('tempdb..#MMarca') is not null drop table #MMarca

	select 
		b.CodPais, 
		c.AnioCampana,b.AnioCampanaExpo ,
		a.PKEbelista,
		b.CodEbelista, 
		c.Codregion, 
		c.CodZona, 
		c.CodComportamientoRolling,
		b.DesnivelComportamiento,
		b.AnioCampanaIngreso,
		b.EdadBelcorp,
		b.FlagPasoPedido, 
		b.Constancia,
		b.FlagTP1,
		b.FlagTP2,
		a.CodMarca, 
		a.CodMarca_F, 
		c.Porc_PUP_Lbel, c.Porc_PUP_Esika, c.Porc_PUP_Cyzone, 
		c.Porc_PUP_CP, c.Porc_PUP_FG, c.Porc_PUP_MQ, c.Porc_PUP_TC, c.Porc_PUP_TF,
		case when CodMarca='A' then Porc_PUP_Lbel
			when CodMarca='B' then Porc_PUP_Esika
			when CodMarca='C' then Porc_PUP_Cyzone 
			else 0 end as Porc_Score,
		a.Score,
		c.OfertaDigitalPU5C,
		--c.OfertaDigitalUC,
		c.MaxRealVtaMNFactura
	into #MMarca
	from #ResultadoMarca a
	inner join #Consultoras b on a.PKEbelista = b.PKEbelista AND a.AnioCampana = B.AnioCampana
	inner join #ResultadoFinal c on a.Pkebelista=c.Pkebelista AND A.AnioCampana = c.AnioCampana
	order by Score desc, Porc_Score desc


	if OBJECT_ID ('tempdb..#M1') is not null drop table #M1
	;with Resumen as
	(
		Select Aniocampana, AnioCampanaExpo,
		avg(Porc_Score) as avg_Porc_Score, 
		stdevp(Porc_Score) as std_Porc_Score, 
		avg(Score) as avg_Score, 
		STDEVP(Score) as std_Score
		from #MMarca where codcomportamientorolling<>1
		group by aniocampana, AniocampanaExpo
	), CompletandoMarca as
	(
		select a.*, 
		case when codcomportamientorolling<>1 then
			(Porc_Score-avg_Porc_Score)/nullif(std_Porc_Score*1.0,0) else 0 end as ZPorc_Score,
		case when codcomportamientorolling<>1 then /*Genera Division por 0 en Panama por eso el null if*/
			(Score- avg_SCore)/nullif(std_Score*1.0,0) else 0 end as ZScore
		from #MMarca a 
		inner join Resumen b on a.AnioCampana=b.AnioCampana
	)
	Select *, 
		case when codcomportamientorolling=1 or CodMarca='Z' then 0
			when (@val9*ZScore-@val8*ZPorc_Score) > 700 and codcomportamientorolling<>1 then 1 
			Else @val10*(exp(@val9*ZScore-@val8*ZPorc_Score)/(1+exp(@val9*ZScore-@val8*ZPorc_Score))) End as ScoreMarca
	into #M1
	from CompletandoMarca
	
	--/* 2 Impulsar Categoría */
	if OBJECT_ID ('tempdb..#CuentaScore45') is not null drop table #CuentaScore45

	;with Categoria as 
	(
		select b.CodPais, 
			c.AnioCampana, 
			b.CodEbelista, 
			c.Codregion, 
			c.CodZona, 
			c.CodComportamientoRolling, 
			a.CodCategoria, 
			c.Porc_PUP_Lbel,c.Porc_PUP_Esika, c.Porc_PUP_Cyzone, 
			c.Porc_PUP_CP,c.Porc_PUP_FG,c.Porc_PUP_MQ,c.Porc_PUP_TC,c.Porc_PUP_TF,
			case when CodCategoria='MQ' then Porc_PUP_MQ
				when CodCategoria='FG' then Porc_PUP_FG
				when CodCategoria='TF' then Porc_PUP_TF
				when CodCategoria='TC' then Porc_PUP_TC
			else Porc_PUP_CP end as Porc_Score,
			a.Score 
			from #ResultadoCategoria a
			inner join #Consultoras b on a.PKEbelista = b.PKEbelista and a.AnioCampana = b.AnioCampana
			inner join #ResultadoFinal c on b.codebelista=c.CodEbelista and a.AnioCampana = c.AnioCampana
	)
	Select 
		AnioCampana,CodRegion, 
		count(CodEbelista) Total,
		sum(case when Score=4 then 1 else 0 end) as CuentaScore4,
		sum(case when Score=5 then 1 else 0 end) as CuentaScore5
	into #CuentaScore45
	from Categoria
	where CodComportamientoRolling in (1,2,3,4,5,6,7) 
	group by AnioCampana,CodRegion

	if OBJECT_ID ('tempdb..#MCategoria') is not null drop table #MCategoria
	

	select 
		b.CodPais, 
		c.AnioCampana, 
		b.CodEbelista, 
		c.CodRegion, 
		c.CodZona, 
		c.CodComportamientoRolling, 
		a.CodCategoria, 
		a.CodCategoria_F, 
		c.Porc_PUP_Lbel,c.Porc_PUP_Esika, c.Porc_PUP_Cyzone, 
		c.Porc_PUP_CP,c.Porc_PUP_FG,c.Porc_PUP_MQ,c.Porc_PUP_TC,c.Porc_PUP_TF,
		case when CodCategoria='MQ' then Porc_PUP_MQ
			when CodCategoria='FG' then Porc_PUP_FG
			when CodCategoria='TF' then Porc_PUP_TF
			when CodCategoria='TC' then Porc_PUP_TC
		else Porc_PUP_CP end as Porc_Score,
		a.Score 
	into #MCategoria
	from #ResultadoCategoria a
	inner join #Consultoras b on a.PKEbelista = b.PKEbelista and a.AnioCampana = b.AnioCampana
	inner join #ResultadoFinal c on a.PKEbelista=c.PKEbelista and a.AnioCampana = c.AnioCampana
	order by Score desc, Porc_Score desc

	if OBJECT_ID ('tempdb..#M2') is not null drop table #M2

	;with Resumen as
	(
		Select 
			aniocampana, 
			avg(Porc_Score) as avg_Porc_Score, 
			stdevp(Porc_Score) as std_Porc_Score, 
			avg(Score) as avg_Score, 
			STDEVP(Score) as std_Score
		from #MCategoria where codcomportamientorolling<>1
		group by aniocampana
	), CompletandoCategoria as
	(
		select a.*, 
		case when codcomportamientorolling<>1 then
			(Porc_Score-avg_Porc_Score)/std_Porc_Score*1.0 else 0 end as ZPorc_Score, 
		case when codcomportamientorolling<>1 then
			(Score- avg_SCore)/std_Score*1.0 else 0 end as ZScore
		from #MCategoria a 
		inner join Resumen b on a.AnioCampana=b.AnioCampana
	)
	Select *, 
		case when codcomportamientorolling=1 or CodCategoria='Z' then 0
		when abs(@val12*ZScore-@val11*ZPorc_Score) > 700 and codcomportamientorolling<>1 then 1 
		else @val13*(exp(@val12*ZScore-@val11*ZPorc_Score)/(1+exp(@val12*ZScore-@val11*ZPorc_Score))) End as ScoreCategoria
	into #M2
	from CompletandoCategoria

	--/* 3 Tip de Productos Top */

	if OBJECT_ID ('tempdb..#M3') is not null drop table #M3
	
	;With Resumen as
	(
		Select 
			aniocampana,
			avg(ProbTop) as avg_ProbTop, 
			stdevp(ProbTop) as std_ProbTop, 
			avg(Pc_PUPTop) as avg_Pc_PUPTop, 
			STDEVP(Pc_PUPTop) as std_Pc_PUPTop
		from #ResultadoTop where codcomportamientorolling<>1
		group by aniocampana
	), PreTop1 as
	(
		Select a.*, 
		case when codcomportamientorolling=1 then 0
		else (ProbTop-avg_ProbTop)/std_ProbTop*1.0 end as Z_ProbTop,
		case when codcomportamientorolling=1 then 0
		else (Pc_PUPTop-avg_Pc_PUPTop)/std_Pc_PUPTop*1.0 end as Z_PcPUPTop
		from #ResultadoTop a
		inner join Resumen b on a.AnioCampana=b.AnioCampana
	)
	Select *, 
		case when codcomportamientorolling=1 then 0
		when abs(@val1*Z_ProbTop+@val2*Z_PcPUPTop)>700 and codcomportamientorolling<>1 then 1 else
		@val3*exp(@val1*Z_ProbTop+@val2*Z_PcPUPTop)/(1+exp(@val1*Z_ProbTop+@val2*Z_PcPUPTop)) End as ScoreTop
	into #M3
	from PreTop1

	--/* 4 Tip de Lanzamientos */
	
	if OBJECT_ID ('tempdb..#M4') is not null drop table #M4
	;with Resumen as
	(
		Select aniocampana, 
			avg(PropensionLanzamiento) as avg_Prob_Lanz, 
			stdevp(PropensionLanzamiento) as std_Prob_Lanz, 
			avg(PorcScore) as avg_PorcScore, STDEVP(PorcScore) as std_PorcScore,
			avg(Venta_Est_Neta) as avg_VtaEstimada, STDEVP(Venta_Est_Neta) as std_VtaEstimada
			from #MensajeLanzamientos where codcomportamientorolling<>1
			group by aniocampana
	), CompletandoLanzamiento as
	(
		Select a.CodPais,
			a.AnioCampana,
			b.CodRegion, 
			b.CodZona, 
			a.CodEbelista,
			b.CodComportamientoRolling, 
			a.CodVenta,--a.CodCUC,
			a.DesProductoCUC,
			a.CodMarca,
			a.DesMarca,
			a.CodCategoria,
			a.NroPedidosconLanzamientos,
			a.NroPedidosComproLanzamientos,
			a.PropensionLanzamiento,
			a.Venta_Est_Neta,
			a.CodCUC as CodCUC_Lanzamientos,
			RankScore,
			PorcScore,
			case when std_Prob_Lanz = 0 then 0 else (a.PropensionLanzamiento-avg_Prob_Lanz)/std_Prob_Lanz*1.0 End as Z_ProbLanz,
			case when std_PorcScore = 0 then 0 else (PorcScore-avg_PorcScore)/std_PorcScore*1.0 End as Z_PorcScore,
			case when std_VtaEstimada = 0 then 0 else (Venta_Est_Neta-avg_VtaEstimada)/std_VtaEstimada*1.0 End as Z_VtaEstimada
		from #MensajeLanzamientos a
		inner join #ResultadoFinal b on a.codebelista=b.CodEbelista and a.AnioCampana = b.AnioCampana
		inner join Resumen c on a.aniocampana=c.aniocampana 
	)
	Select *,
	case when CodComportamientoRolling<>1 then
	@val7*exp(@val4*Z_ProbLanz+@val5*Z_PorcScore+@val6*Z_VtaEstimada)/(1+exp(@val4*Z_ProbLanz+@val5*Z_PorcScore+@val6*Z_VtaEstimada)) else 0 end as ScoreLanzamiento
	into #M4
	from CompletandoLanzamiento

	
	--/* 5 Ampliación de Clientes - 6 Visitar Clientes */
	if OBJECT_ID ('tempdb..#M5_M6') is not null drop table #M5_M6

	;with Tabla1 as (
		select 
			CodPais, 
			AnioCampana, 
			CodEbelista, 
			CodRegion, 
			CodZona, 
			CodComportamientoRolling, 
			PSPU3C, 
			UUCampXmenos0, UUCampXmenos1, UUCampXmenos2, UUCampXmenos3, UUCampXmenos4,
			case when UUCampXmenos0-UUCampXmenos1 <=0 then 1
			when UUCampXmenos1-UUCampXmenos2 <=0 then 2
			when UUCampXmenos2-UUCampXmenos3 <=0 then 3
			when UUCampXmenos3-UUCampXmenos4 <=0 then 4
			else 0 end RecenciaCaida,
			sum(case when UUCampXmenos0-UUCampXmenos1 <=0 then 1 else 0 end +
			case when UUCampXmenos1-UUCampXmenos2 <=0 then 1 else 0 end +
			case when UUCampXmenos2-UUCampXmenos3 <=0 then 1 else 0 end +
			case when UUCampXmenos3-UUCampXmenos4 <=0 then 1 else 0 end) FrecuenciaCaida
		from #ResultadoFinal
		group by CodPais, AnioCampana, CodEbelista, CodRegion, CodZona, 
		CodComportamientoRolling, PSPU3C, UUCampXmenos0, UUCampXmenos1, UUCampXmenos2, UUCampXmenos3, UUCampXmenos4,
		case when UUCampXmenos0-UUCampXmenos1 <=0 then 1
		when UUCampXmenos1-UUCampXmenos2 <=0 then 2
		when UUCampXmenos2-UUCampXmenos3 <=0 then 3
		when UUCampXmenos3-UUCampXmenos4 <=0 then 4
		else 0 end 
	), TablaResumen as
	(
		Select aniocampana, 
			avg(PSPU3C) as avg_PSPU3C, 
			stdevp(PSPU3C) std_PSPU3C,
			avg(FrecuenciaCaida) as avg_FrecuenciaCaida, 
			stdevp(FrecuenciaCaida) std_FrecuenciaCaida,
			avg(RecenciaCaida) as avg_RecenciaCaida, 
			stdevp(RecenciaCaida) std_RecenciaCaida
		from Tabla1 where codcomportamientorolling<>1
		group by aniocampana
	), Tabla2 as 
	(
		Select CodPais,
			b.AnioCampana,
			CodEbelista,
			CodRegion,
			CodZona,
			CodComportamientoRolling,
			PSPU3C, FrecuenciaCaida, RecenciaCaida,
			(PSPU3C-avg_PSPU3C)/std_PSPU3C as Z_PSPU3C,
			case when std_FrecuenciaCaida = 0 then 0 else (FrecuenciaCaida-avg_FrecuenciaCaida)/std_FrecuenciaCaida End as Z_FrecuenciaCaida,
			case when std_RecenciaCaida  = 0 then 0 else (RecenciaCaida-avg_RecenciaCaida)/std_RecenciaCaida End as Z_RecenciaCaida
		from Tabla1 a 
		inner join TablaResumen b on a.aniocampana=b.aniocampana
	), TablaResumen2 as 
	(
		Select AnioCampana, avg(Z_FrecuenciaCaida-Z_RecenciaCaida) as avg_FR, stdevp(Z_FrecuenciaCaida-Z_RecenciaCaida) as std_FR
		from Tabla2 where codcomportamientorolling<>1
		group by Aniocampana
	), Tabla3 as 
	(
		Select CodPais,
			a.AnioCampana,
			CodEbelista,
			CodRegion,
			CodZona,
			CodComportamientoRolling,
			PSPU3C,FrecuenciaCaida,RecenciaCaida, 
			Z_PSPU3C,Z_FrecuenciaCaida,Z_RecenciaCaida,
			case when std_FR  = 0 then 0 else ((Z_FrecuenciaCaida-Z_RecenciaCaida)-avg_FR)/std_FR end as Z_FR
			from Tabla2 a inner join TablaResumen2 b on a.aniocampana=b.aniocampana
	)
	Select 
		CodPais,
		AnioCampana,
		CodEbelista,
		CodRegion,
		CodZona,
		CodComportamientoRolling,
		PSPU3C,FrecuenciaCaida,RecenciaCaida, Z_FR,
		Z_PSPU3C,Z_FrecuenciaCaida,Z_RecenciaCaida,
		case when codcomportamientorolling=1 then 0
		else exp(-1.5*Z_PSPU3C+Z_FR)/(1+exp(-1.5*Z_PSPU3C+Z_FR)) end as ScoreMasClientes,
		case when codcomportamientorolling=1 then 0
		else exp(+Z_PSPU3C+1.5*Z_FR)/(1+exp(+Z_PSPU3C+1.5*Z_FR)) end as ScoreVisitas
	into #M5_M6
	from Tabla3 
	where PSPU3C>0
	order by ScoreMasClientes desc

	--/* 7 Resto de Mensajes */
	if OBJECT_ID ('tempdb..#M_Resto') is not null drop table #M_Resto
	--NroLogueos
	;with Resumen as 
	(
		   Select CodPais,AnioCampana,avg(Porc_PedidosWebU6C) as avg_PcPedWeb,stdevp(Porc_PedidosWebU6C) as stdevp_PcPedWeb,
				 avg(Porc_PedidosIPUnicoU6C) as avg_PcPedIpUnico, stdevp(Porc_PedidosIPUnicoU6C) as stdevp_PcPedIpUnico,
				 avg(Porc_PedidosOfertaDigitalU6C) as avg_Plan20,stdevp(Porc_PedidosOfertaDigitalU6C) as stdevp_Plan20,
				 avg(RecenciaPedidoWebU6C*1.0) as avg_RecenciaWeb,stdevp(RecenciaPedidoWebU6C*1.0) as stdevp_RecenciaWeb,
				 avg(Porc_RevistaU6C) as avg_PcRevista, stdevp(Porc_RevistaU6C) as stdevp_PcRevista,
				 avg(NroLogueos) as avg_NroLogueos, stdevp(NroLogueos) as stdevp_NroLogueos
		   from #ResultadoFinal where codcomportamientorolling<>1
		   group by CodPais,AnioCampana

	), Tablas as
	(      
		   Select a.*,
				 case when stdevp_PcPedWeb = 0 then 0 else (Porc_PedidosWebU6C-avg_PcPedWeb)/stdevp_PcPedWeb*1.0 End as Z_PcPedWeb,
				 case when stdevp_PcPedIpUnico = 0 then 0 else (Porc_PedidosIPUnicoU6C-avg_PcPedIpUnico)/stdevp_PcPedIpUnico*1.0 End as Z_PcIpUnico,
				 case when stdevp_Plan20 = 0 then 0 else (Porc_PedidosOfertaDigitalU6C-avg_Plan20)/stdevp_Plan20*1.0 End as Z_Plan20,
				 case when stdevp_RecenciaWeb = 0 then 0 else (RecenciaPedidoWebU6C-avg_RecenciaWeb)/stdevp_RecenciaWeb*1.0 End as Z_RecenciaWeb,
				 case when stdevp_PcRevista = 0 then 0 else (Porc_RevistaU6C-avg_PcRevista)/stdevp_PcRevista*1.0 End as Z_PcRevista,
				 case when stdevp_NroLogueos = 0 then 0 else (NroLogueos-avg_NroLogueos)/stdevp_NroLogueos*1.0 End as Z_NroLogueos
		   from #ResultadoFinal a
		   inner join Resumen b on a.aniocampana=b.aniocampana
	)Select 
		a.CodPais,
		a.AnioCampana,
		a.Pkebelista,
		a.CodEbelista,
		a.CodRegion,a.CodZona,
		a.CodComportamientoRolling, a.Edad,
		a.Porc_PedidosWebU6C, Porc_PedidosIPUnicoU6C, Porc_PedidosOfertaDigitalU6C,RecenciaPedidoWebU6C,Porc_RevistaU6C,
		a.MaxRealVtaMNFactura, 
		a.NroLogueos,
		a.MaxDescuento, 
		--a.PosiblePrimeraCompraOnline, 
		--a.PosiblePrimeraCompraPlan20,
		b.PSPU3C,b.FrecuenciaCaida,Z_PcPedWeb,Z_PcIpUnico,Z_Plan20,Z_RecenciaWeb,Z_NroLogueos,
		case when a.codcomportamientorolling=1 then 0 else 
		exp(Z_PcRevista+Z_PcPedWeb)/(1+exp(Z_PcRevista+Z_PcPedWeb)) end as ScoreTipCatalogo,
		case when a.codcomportamientorolling=1 then 0 else 
		0.9*(exp(2*Z_RecenciaWeb-5*Z_PcIpUnico)/(1+exp(2*Z_RecenciaWeb-5*Z_PcIpUnico))) end as ScoreTipPedidoOnLine,
		case when a.codcomportamientorolling=1 then 0 else 
		exp(-Z_PcRevista+Z_PcIpUnico)/(1+exp(-Z_PcRevista+Z_PcIpUnico)) end as ScoreRecordaCatalogo,
		case when a.codcomportamientorolling=1 then 0 else 
		exp(+Z_RecenciaWeb+Z_PcIpUnico)/(1+exp(Z_RecenciaWeb+Z_PcIpUnico)) end as ScoreRecordaPedidoOnLine,
		case when a.codcomportamientorolling=1 then 0 else 
		exp(+b.Z_FrecuenciaCaida-Z_PSPU3C+Z_PcRevista)/(1+exp(+b.Z_FrecuenciaCaida-Z_PSPU3C+Z_PcRevista)) end as ScoreTipCobranza,
		case when a.codcomportamientorolling=1 then 0 else 
		exp(-Z_Plan20+Z_PcIpUnico)/(1+exp(-Z_Plan20+Z_PcIpUnico)) end as ScorePlan20,
		case when a.codcomportamientorolling=1 then 0 else 
		exp(-Z_NroLogueos+Z_PcIpUnico)/(1+exp(-Z_NroLogueos+Z_PcIpUnico)) end as ScoreTipGestionDigital
	into #M_Resto
	from Tablas a
	inner join #M5_M6 b on a.CodEbelista=b.Codebelista and a.AnioCampana = b.AnioCampana
	order by pkebelista

	/*Agregando Variables de Fuga*/ --Revisar!!!!!!! 
	if OBJECT_ID ('tempdb..#Pre_Fuga') is not null drop table #Pre_Fuga
	SELECT*, 
	NTILE (10) OVER ( partition by CodPais, AnioCampana order by Prob_NPP desc )  as Decil_Pais
	into #Pre_Fuga
	FROM BD_ANALITICO.DBO.MDL_MATRIZFUGA_OUTPUT  
	where codpais=@codpais and AnioCampana in (SELECT AnioCampanaExpo FROM @TAnioCampana) --***

	if OBJECT_ID ('tempdb..#FUGA') is not null drop table #FUGA
	SELECT B.CodPais,B.AnioCampana,B.Pkebelista,B.CodEbelista,B.CodRegion,B.CodZona,
	CASE WHEN A.Prob_NPP>0 THEN A.Prob_NPP ELSE 99 END Prob_NPP,
	CASE WHEN A.Decil_Pais>0 THEN A.Decil_Pais ELSE 99 END Decil_Pais
	INTO #FUGA
	FROM #Pre_Fuga	A
	RIGHT JOIN #ResultadoFinal B ON A.PKEBELISTA=B.PKEBELISTA AND B.AnioCampanaExpo = A.AnioCampana

	if (@FlagLog = 1) print 'Insert ARMSG_Analytics_Full: ' + cast(@item as varchar) + ' - ' + convert(varchar, @m_time, 103) + ' ' + convert(varchar, @m_time, 108) + ' :dd:' + CAST(datediff(SS, @m_time, GETDATE()) AS VARCHAR)  

	select @m_time  = GETDATE(), @item = @item+1  

	delete from BD_ANALITICO.dbo.ARMSG_Analytics_Full
	where CodPais = @CodPais and AnioCampana in (SELECT DISTINCT AnioCampana FROM @TAnioCampana)
	
/* DATA COMPLETA PARA ANALISIS - PARA MILY*/
insert into BD_ANALITICO.dbo.ARMSG_Analytics_Full
Select 
	a.CodPais,
	a.AnioCampana,
	a.AnioCampanaExpo,
	CASE a.CodComportamientoRolling WHEN 1 THEN 'N' ELSE 'E' END as TipoConsultora,
	a.CodEbelista,
	a.PkEbelista,
	a.AnioCampanaIngreso,
	a.CodRegion,
	a.CodZona,
	a.CodComportamientoRolling,
	a.DesnivelComportamiento,
	a.Constancia as DesConstanciaNuevas,
	a.FlagTP1,
	a.FlagTP2,
	a.CodMarca,
	a.CodMarca_F,
	case a.CodMarca_F
	when 'A' THEN 'L''BEL' 
	WHEN 'B' THEN 'ESIKA' 
	WHEN 'C' THEN 'CYZONE' 
	ELSE a.CodMarca_F END as DesMarcaScore,
	b.CodCategoria,
	b.CodCategoria_F,
	CASE b.CodCategoria_F when 'MQ' THEN 'MAQUILLAJE' 
			WHEN 'FG' THEN 'FRAGANCIAS' 
			WHEN 'CP' THEN 'CUIDADO PERSONAL'
			WHEN 'TF' THEN 'TRATAMIENTO FACIAL'
			WHEN 'TC' THEN 'TRATAMIENTO CORPORAL' 
	else b.CodCategoria_F END as DesCategoriaScore,
	a.Porc_PUP_Lbel, 
	a.Porc_PUP_Esika, 
	a.Porc_PUP_Cyzone,
	a.Porc_PUP_CP, 
	a.Porc_PUP_FG, 
	a.Porc_PUP_MQ, 
	a.Porc_PUP_TC, 
	a.Porc_PUP_TF,
	b.Porc_Score as Pc_ScoreCategoria, 
	b.Score as PseudoScoreCategoria,
	a.Porc_Score as Pc_ScoreMarca,
	a.Score as PseudoScoreMarca,
	c.PUPTop, 
	c.PUPU6C, 
	c.Pc_PUPTop, 
	c.ProbTop, 
	c.CodMarcaAfin,
	c.CodCategoriaAfin,
	c.CodVenta as CodVenta_Top,
	c.DesProductoCUC as DesProductoCUC_Top,
	d.NroPedidosconLanzamientos,
	d.NroPedidosComproLanzamientos,
	d.PropensionLanzamiento,
	d.PorcScore as SumaPorcLanz,
	d.Venta_Est_Neta,
	d.CodVenta as CodVenta_Lanzamiento,
	d.DesProductoCUC as DesProductoCUC_Lanzamiento,
	e.PSPU3C,
	e.FrecuenciaCaida,
	e.RecenciaCaida,
	f.Porc_PedidosWebU6C, 
	f.Porc_PedidosIPUnicoU6C, 
	f.Porc_PedidosOfertaDigitalU6C, 
	f.RecenciaPedidoWebU6C, 
	f.Porc_RevistaU6C,
	f.NroLogueos,
	a.ScoreMarca, 
	b.ScoreCategoria, 
	c.ScoreTop,
	d.ScoreLanzamiento,
	e.ScoreMasClientes,
	e.ScoreVisitas,
	f.ScoreTipCatalogo, 
	f.ScoreTipPedidoOnLine, 
	f.ScoreRecordaCatalogo, 
	f.ScoreRecordaPedidoOnLine, 
	f.ScoreTipCobranza, 
	f.ScorePlan20,
	f.ScoreTipGestionDigital,
	f.MaxRealVtaMNFactura, 
	f.MaxDescuento, 
	--f.PosiblePrimeraCompraOnline, 
	--f.PosiblePrimeraCompraPlan20,
	a.FlagPasoPedido,
	a.OfertaDigitalPU5C,
	--a.OfertaDigitalUC,
	G.Prob_NPP,
	G.Decil_Pais
from #M1 a
inner join #M2 b on a.codebelista=b.codebelista and a.AnioCampana = b.AnioCampana and a.CodPais = b.CodPais 
inner join #M3 c on a.codebelista=c.codebelista and a.AnioCampana = c.AnioCampana and a.CodPais = c.CodPais 
left join #M4 d on a.codebelista=d.codebelista and a.AnioCampana = d.AnioCampana and a.CodPais = d.CodPais 
inner join #M5_M6 e on a.codebelista=e.codebelista and a.AnioCampana = e.AnioCampana and a.CodPais = e.CodPais 
inner join #M_Resto f on a.CodEbelista=f.CodEbelista and a.AnioCampana = f.AnioCampana and a.CodPais = f.CodPais 
left join #FUGA G ON a.CodEbelista=G.CodEbelista and a.AnioCampana = g.AnioCampana and a.CodPais = g.CodPais 
order by a.CodEbelista

--1 2 4 Resto fuga

if (@FlagLog = 1) print 'Insert ARMSG_AnalyticsOutput: ' + cast(@item as varchar) + ' - ' + convert(varchar, @m_time, 103) + ' ' + convert(varchar, @m_time, 108) + ' :dd:' + CAST(datediff(SS, @m_time, GETDATE()) AS VARCHAR)  
	select @m_time  = GETDATE(), @item = @item+1  

/*Envio al PCC*/

IF OBJECT_ID('tempdb..#TMP_AnalyticsOutput') IS NOT NULL DROP TABLE #TMP_AnalyticsOutput

Select 
	a.CodPais,
	@DesPais as DesPais ,
	a.AnioCampana,
	a.AnioCampanaExpo,
	CAST(NULL AS VARCHAR) as FechaEnvio,
	a.CodEbelista,
	NULL as CodComportamiento,--a.CodComportamientoRolling as CodComportamiento,
	a.AnioCampanaIngreso,
	a.EdadBelcorp,
	ISNULL(a.ScoreMarca,0) as ScoreMarca,
	ISNULL(b.ScoreCategoria,0) as ScoreCategoria,  
	ISNULL(c.ScoreTop,0) as ScoreTop,
	ISNULL(d.ScoreLanzamiento,0) as ScoreLanzamiento,
	ISNULL(e.ScoreVisitas,0) as ScoreVisitas,
	ISNULL(f.ScoreTipGestionDigital,0) as ScoreTipGestionDigital,
	ISNULL(f.ScoreTipCobranza,0) as ScoreTipCobranza,
	ISNULL(e.ScoreMasClientes,0) as ScoreMasClientes,
	ISNULL(f.ScoreTipPedidoOnLine,0) as ScoreTipPedidoOnLine,
	ISNULL(G.Prob_NPP,0) Prob_NPP,
	NULL as DesConstanciaNuevas,--a.Constancia as DesConstanciaNuevas,
	NULL as FlagTP1,--a.FlagTP1,
	NULL as FlagTP2,--a.FlagTP2,
	a.OfertaDigitalPU5C,
	NULL as FlagOfertaDigitalUC,--a.OfertaDigitalUC as FlagOfertaDigitalUC,
	f.MaxRealVtaMNFactura as MaxVentaFacturadaPU5C,
	case a.CodMarca_F when 'A' THEN 'L''BEL' WHEN 'B' THEN 'ESIKA' WHEN 'C' THEN 'CYZONE' 
		ELSE a.CodMarca_F END as DesMarcaScore,
	b.CodCategoria_F as DesCategoriaScore,
	c.CodVenta as CodVenta_Top,
	c.CodCUC as CodCUC_Top,
	c.DesMarca as Marca_top,
	c.CodCategoria as Categoria_top,
	d.CodVenta as CodVenta_Lanzamiento,
	d.CodCUC_Lanzamientos as CodCUC_Lanzamiento,
	d.DesMarca as Marca_Lanzamiento,
	d.CodCategoria as Categoria_Lanzamiento
INTO #TMP_AnalyticsOutput
from #M1 a 
inner join #M2 b on a.codebelista=b.codebelista and a.AnioCampana = b.AnioCampana
inner join #M3 c on a.codebelista=c.codebelista and a.AnioCampana = c.AnioCampana 
left join #M4 d on a.codebelista=d.codebelista and a.AnioCampana = d.AnioCampana
inner join #M5_M6 e on a.codebelista=e.codebelista and a.AnioCampana = e.AnioCampana
inner join #M_Resto f on a.CodEbelista=f.CodEbelista and a.anioCampana = f.AnioCampana
left join #FUGA G ON a.CodEbelista=G.CodEbelista and a.AnioCampana = g.AnioCampana
order by a.CodEbelista

if (@FlagLog = 1) print 'Fecha de Envio:  ' + cast(@item as varchar) + ' - ' + convert(varchar, @m_time, 103) + ' ' + convert(varchar, @m_time, 108) + ' :dd:' + CAST(datediff(SS, @m_time, GETDATE()) AS VARCHAR)  
	select @m_time  = GETDATE(), @item = @item+1  
	
	UPDATE A 
	SET A.FechaEnvio = B.FechaEnvio
	FROM #TMP_AnalyticsOutput A 
	INNER JOIN BD_ANALITICO.dbo.ARMSG_AnalyticsOutput B ON A.AnioCampana = B.AnioCampana AND A.Codebelista = B.Codebelista AND A.CodPais = B.CodPais
	WHERE A.FechaEnvio IS NULL 

	UPDATE A
	SET A.FechaEnvio =  cast(format(getdate(),'yyyyMMdd') as int)
	FROM #TMP_AnalyticsOutput A
	WHERE A.FechaEnvio IS NULL

	delete from  BD_ANALITICO.dbo.ARMSG_AnalyticsOutput
	where CodPais = @CodPais and AnioCampana in (SELECT DISTINCT AnioCampana FROM @TAnioCampana)
		
	INSERT INTO BD_ANALITICO.dbo.ARMSG_AnalyticsOutput
	SELECT * FROM #TMP_AnalyticsOutput WHERE AnioCampana in (SELECT DISTINCT AnioCampana FROM @TAnioCampana)

	/*Insertando la Info para que se lleve a ODS */
	delete from  BD_ANALITICO.dbo.MDL_VirtualCoach_AnalyticsOutput
	where CodPais = @CodPais

	INSERT INTO BD_ANALITICO.dbo.MDL_VirtualCoach_AnalyticsOutput
	SELECT * FROM #TMP_AnalyticsOutput WHERE AnioCampana in (SELECT DISTINCT AnioCampana FROM @TAnioCampana)

	
if (@FlagLog = 1) print 'Fin Proceso ' + cast(@item as varchar) + ' - ' + convert(varchar, @m_time, 103) + ' ' + convert(varchar, @m_time, 108) + ' :dd:' + CAST(datediff(SS, @m_time, GETDATE()) AS VARCHAR)  

-- SELECT DISTINCT AnioCampana, CodRegion FROM #ARMSG_Variables 

	if (@FlagLog = 1) print 'Fin Proceso ' + cast(@item as varchar) + ' - ' + convert(varchar, @m_time, 103) + ' ' + convert(varchar, @m_time, 108) + ' :dd:' + CAST(datediff(SS, @m_time, GETDATE()) AS VARCHAR)  

	select @m_time  = GETDATE(), @item = @item+1  

	/*Imprimiendo Resultados Principales*/
	print '*******************************'
		DECLARE @Cantconsultoras INT
		DECLARE @CantconsultorasIni INT
		
		SELECT @CantconsultorasIni = COUNT(DISTINCT CodEbelista) FROM #Consultoras

		SELECT @Cantconsultoras = COUNT(DISTINCT CodEbelista) FROM #TMP_AnalyticsOutput
		WHERE AnioCampana in (SELECT AnioCampana FROM @TAnioCampana) and CodPais = @CodPais
	
	if (@FlagLog = 1) print 'Cantidad de Consultoras de ##Consultoras '+ @CodPais +' : '+ cast(@CantconsultorasIni as varchar)
	
	print 'Cantidad de Consultoras de AnalyticsOutput '+ @CodPais +' : '+ cast(@Cantconsultoras as varchar)
	print 'AnioCampana Proceso '+ @CodPais +' : '+ cast(@AnioCampana as varchar)
	print 'AnioCampana Exposicioón '+ @CodPais +' : '+ cast(@AnioCampana_Expo as varchar)

END
