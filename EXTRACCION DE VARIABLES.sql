


---------VAR OBJETIVO-----------
drop table #cosechaestablecidas
select CodPais, AnioCampana, PkEbelista, CodComportamientoRolling into #cosechaestablecidas
from  [DWH_ANALITICO].DBO.DWH_FSTAEBECAM
where CodPais = 'GT'  and AnioCampana = '201713' and CodComportamientoRolling in (2, 3,4,5,6,7) 

drop table #vtas3camp
select a.PkEbelista, a.AnioCampana, sum(RealVtaMNNeto) as vta
into #vtas3camp
from [DWH_ANALITICO].DBO.DWH_FVTAPROEBECAM a inner join [DWH_ANALITICO].DBO.DWH_FSTAEBECAM b  on a.PkEbelista = b.PkEBELISTA and a.CodPais = b.CodPais
inner join [DWH_ANALITICO].DBO.DWH_DTIPOOFERTA c on  a.PKTipoOferta = c.PKTipoOferta  and a.CodPais = c.CodPais 
where a.CodPais = 'GT' 
and a.PkEbelista in (select PkEbelista from #cosechaestablecidas)
and CodTipoProfit = '01'
and a.AnioCampana in ('201711', '201712', '201713', '201715')
and a.AnioCampana = a.AnioCampanaRef
group by a.PkEbelista, a.AnioCampana
order by PkEBelista, AnioCampana

select PkEBELISTA, count(1)
from #vtas3camp
group by PkEbelista
having count(1) = 4
order by count(1) desc
--15605

drop table #vtasTrasp
SELECT Pkebelista, [201711] as v201711,[201712] as v201712, [201713] as v201713,[201715] as v201715  into #vtasTrasp
FROM
(    SELECT * FROM #vtas3camp
) AS SourceTable PIVOT(AVG([vta]) FOR [AnioCampana] IN([201711],
[201712], [201713], [201715] )) AS PivotTable

drop table #ventascons										
select * into #ventascons from #vtasTrasp where 
v201711 is not null and
v201712 is not null
and  v201713 is not null and  v201715 is not null
   
select PkEbelista, Ntile (10) over (order by v201713 desc), v201713 from #ventascons
--15604

---------VAR 2-----------
select b.PkEBELISTA, count(1) as Pedidos_ult_18camp
from #ventascons a inner join [DWH_ANALITICO].DBO.DWH_FSTAEBECAM b on a.PkEbelista = b.PkEbelista
where b.AnioCampana in ('201713','201712','201711','201710','201709','201708','201707','201706','201705',
'201704','201703','201702','201701','201618','201617','201616','201615','201614') and CodPais = 'GT'
group by b.Pkebelista 
order by  count(1)


---------VAR 4-----------
drop table #ventacampanterior
select a.PkEbelista, a.AnioCampana, sum(RealVtaMNNeto) as vta into #ventacampanterior
from [DWH_ANALITICO].DBO.DWH_FVTAPROEBECAM a inner join [DWH_ANALITICO].DBO.DWH_FSTAEBECAM b  on a.PkEbelista = b.PkEBELISTA and a.CodPais = b.CodPais
inner join [DWH_ANALITICO].DBO.DWH_DTIPOOFERTA c on  a.PKTipoOferta = c.PKTipoOferta  and a.CodPais = c.CodPais 
where a.CodPais = 'GT' 
and CodTipoProfit = '01'
and a.AnioCampana = '201712'
and a.AnioCampana = a.AnioCampanaRef
group by a.PkEbelista, a.AnioCampana
order by PkEBelista, AnioCampana

drop table #decilcampanterior
select a.PkEbelista, Ntile (10) over (order by vta desc) as [Decil], vta, b.pkebelista #decilcampanterior
from #ventascons a  inner join #ventacampanterior b on a.PkEBELISTA = B.pKebelista


---------VAR 5-----------
select DesMarca, DesCategoria, DesTipo, DesSubCategoria, DesSubCategoriaSolo, DesTipoSolo, DesSubTipoSolo from DPRODUCTO

select * from FSTAEBECAMC01 where AnioCampana in ('201714', '201713', '201712')		
---------VAR 6----------- FIX!
drop table #PPU
select  PKEbelista, AnioCampana, count(RealVtaMNNeto) as qprod, sum(RealVtaMNNeto) as vta, sum(RealVtaMNNeto)/count(RealVtaMNNeto) as PPU into #PPU
from [DWH_ANALITICO].DBO.DWH_FVTAPROEBECAM a inner join [DWH_ANALITICO].DBO.DWH_DTIPOOFERTA b on a.PKTipoOferta = b.PKTipoOferta  and a.CodPais = b.CodPais
where a.CodPais = 'GT'  and AnioCampana in ('201713','201712','201711') and AnioCampana = AnioCampanaRef and CodTipoProfit = '01'
group by PKEbelista, AnioCampana
order by PkEbelista, AnioCampana

drop table #PPUTrasp
SELECT Pkebelista, [201711] as v201711,[201712] as v201712, [201713] as v201713  into #PPUTrasp
FROM
(    SELECT * FROM #PPU
) AS SourceTable PIVOT(AVG([PPU]) FOR [AnioCampana] IN([201711], [201712],
[201713])) AS PivotTable


select * from #PPUTrasp
ORDER BY PKEBELISTA
where v201712 is not null
and  v201713 is not null and  v201711 is not null

---------VAR 7-----------

select PkEBELISTA, AnioCampana,  QPROD from #PPU
order by PkEbelista, AnioCampana

---------VAR 8-----------

SELECT PkEbelista, FlagIpUnicoZona FROM
[DWH_ANALITICO].DBO.DWH_FSTAEBECAM
where CodPais = 'GT'  and AnioCampana = '201713' and CodComportamientoRolling in (2, 3,4,5,6,7) 

---------VAR 9-----------

drop table #PD

SELECT PkEbelista, AnioCampana, FlagCompraOPT + FlagCompraODD + FlagCompraOF + FlagCompraFDC + FlagCompraSR as PalancaDigital into #PD
FROM [DWH_ANALITICO].DBO.DWH_FSTAEBECAM 
where CodPais = 'GT'  and AnioCampana in ('201713', '201712', '201711') and CodComportamientoRolling in (2, 3,4,5,6,7) and FlagPasoPedido = 1
order by PkEBELISTA


select PkEBELISTA, COUNT(1) pedidos INTO #ConsultorasPD
from #pd
group by PkEbelista
HAVING COUNT(1) = 3

drop table #consultorasPD2
select a.PkEbelista, AnioCampana, PalancaDigital into #consultorasPD2 
from #PD a inner join #consultorasPD b on a.PkEBELISTA = B.PKEBELISTA
order by PkEBELISTA

drop table #PD2Trasp
SELECT Pkebelista, [201711] as pd201711,[201712] as pd201712, [201713] as pd201713  into #PD2Trasp
FROM
(    SELECT * FROM #consultorasPD2
) AS SourceTable PIVOT(AVG([PalancaDigital]) FOR [AnioCampana] IN([201711], [201712],
[201713])) AS PivotTable


select * from #PD2Trasp

---------VAR 10-----------
select a.PkEbelista, v201711, v201712, v201713, v201715, CodComportamientoRolling 
from #ventascons a inner join #cosechaestablecidas b on a.PkEBELISTA = b.PkEBELISTA
order by CodComportamientoRolling


---------VAR 11-----------
select FechaNacimiento from [DWH_ANALITICO].DBO.DWH_DEBELISTA
where CodPais = 'GT'
and PkEbelista in (select PkEbelista from #ventascons)


													
						