-- ============================================================
-- QUERY 6 — Hall da Fama: Top 5 alunos com mais acertos
-- Mínimo de 100 questões respondidas em sessões concluídas
-- ============================================================
SELECT
    p.nome_completo                     AS aluno,
    SUM(ss.total_acertos)               AS total_acertos,
    SUM(ss.total_questoes)              AS total_questoes_respondidas
FROM public.perfis p
JOIN public.sessoes_simulado ss ON ss.aluno_id = p.id
WHERE ss.status = 'concluida'
GROUP BY p.id, p.nome_completo
HAVING SUM(ss.total_questoes) >= 100
ORDER BY total_acertos DESC
LIMIT 5;
