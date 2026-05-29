-- ============================================================
-- QUERY 2 — Alunos que nunca iniciaram uma sessão de simulado
-- ============================================================
SELECT
    p.id,
    p.nome_completo
FROM public.perfis p
WHERE p.papel = 'aluno'
  AND NOT EXISTS (
      SELECT 1
      FROM public.sessoes_simulado ss
      WHERE ss.aluno_id = p.id
  )
ORDER BY p.nome_completo;
