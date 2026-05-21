-- ============================================================
-- SIMULADOR ENEM — 03_rls.sql
-- Row Level Security — políticas de acesso por linha
-- Executar APÓS 02_triggers.sql
-- ============================================================

-- ============================================================
-- Funções auxiliares (helpers)
-- Retornam dados do usuário autenticado no momento
-- ============================================================

-- Retorna o id do perfil do usuário logado
CREATE OR REPLACE FUNCTION public.perfil_id_atual()
RETURNS UUID LANGUAGE sql STABLE SECURITY DEFINER AS $$
    SELECT id FROM public.perfis WHERE auth_id = auth.uid()
$$;

-- Retorna o papel (aluno / admin_escolar / admin_global) do usuário logado
CREATE OR REPLACE FUNCTION public.papel_atual()
RETURNS TEXT LANGUAGE sql STABLE SECURITY DEFINER AS $$
    SELECT papel FROM public.perfis WHERE auth_id = auth.uid()
$$;

-- Retorna o id da escola gerenciada pelo admin_escolar logado
CREATE OR REPLACE FUNCTION public.escola_gerenciada_id()
RETURNS UUID LANGUAGE sql STABLE SECURITY DEFINER AS $$
    SELECT id FROM public.escolas WHERE admin_id = public.perfil_id_atual()
$$;


-- ============================================================
-- TABELA: perfis
-- Aluno: lê e edita apenas o próprio perfil
-- Admin escolar / global: lê todos os perfis
-- ============================================================
ALTER TABLE public.perfis ENABLE ROW LEVEL SECURITY;

CREATE POLICY "perfis: leitura do próprio perfil"
    ON public.perfis FOR SELECT
    USING (
        id = public.perfil_id_atual()
        OR public.papel_atual() IN ('admin_global', 'admin_escolar')
    );

CREATE POLICY "perfis: atualização do próprio perfil"
    ON public.perfis FOR UPDATE
    USING (id = public.perfil_id_atual())
    WITH CHECK (id = public.perfil_id_atual());


-- ============================================================
-- TABELA: escolas
-- Admin global: acesso total
-- Admin escolar: lê e edita apenas a própria escola
-- ============================================================
ALTER TABLE public.escolas ENABLE ROW LEVEL SECURITY;

CREATE POLICY "escolas: admin_global acesso total"
    ON public.escolas FOR ALL
    USING (public.papel_atual() = 'admin_global');

CREATE POLICY "escolas: admin_escolar lê a própria"
    ON public.escolas FOR SELECT
    USING (admin_id = public.perfil_id_atual());

CREATE POLICY "escolas: admin_escolar edita a própria"
    ON public.escolas FOR UPDATE
    USING (admin_id = public.perfil_id_atual())
    WITH CHECK (admin_id = public.perfil_id_atual());


-- ============================================================
-- TABELA: matriculas
-- Aluno: lê apenas os próprios vínculos
-- Admin escolar: gerencia matrículas da sua escola
-- Admin global: acesso total
-- ============================================================
ALTER TABLE public.matriculas ENABLE ROW LEVEL SECURITY;

CREATE POLICY "matriculas: aluno vê os próprios vínculos"
    ON public.matriculas FOR SELECT
    USING (aluno_id = public.perfil_id_atual());

CREATE POLICY "matriculas: admin_escolar gerencia alunos da escola"
    ON public.matriculas FOR ALL
    USING (escola_id = public.escola_gerenciada_id());

CREATE POLICY "matriculas: admin_global acesso total"
    ON public.matriculas FOR ALL
    USING (public.papel_atual() = 'admin_global');


-- ============================================================
-- TABELA: questoes
-- Qualquer autenticado: leitura (acervo compartilhado)
-- Admin global: escrita, edição e exclusão
-- ============================================================
ALTER TABLE public.questoes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "questoes: leitura para qualquer autenticado"
    ON public.questoes FOR SELECT
    USING (auth.role() = 'authenticated');

CREATE POLICY "questoes: escrita somente admin_global"
    ON public.questoes FOR ALL
    USING (public.papel_atual() = 'admin_global');


-- ============================================================
-- TABELA: sessoes_simulado
-- Aluno: acessa apenas as próprias sessões
-- Admin escolar: lê sessões dos alunos da sua escola
-- Admin global: acesso total
-- ============================================================
ALTER TABLE public.sessoes_simulado ENABLE ROW LEVEL SECURITY;

CREATE POLICY "sessoes: aluno acessa as próprias"
    ON public.sessoes_simulado FOR ALL
    USING (aluno_id = public.perfil_id_atual());

CREATE POLICY "sessoes: admin_escolar audita alunos da escola"
    ON public.sessoes_simulado FOR SELECT
    USING (
        aluno_id IN (
            SELECT aluno_id FROM public.matriculas
            WHERE escola_id = public.escola_gerenciada_id()
        )
    );

CREATE POLICY "sessoes: admin_global acesso total"
    ON public.sessoes_simulado FOR ALL
    USING (public.papel_atual() = 'admin_global');


-- ============================================================
-- TABELA: respostas
-- Aluno: acessa respostas das próprias sessões
-- Admin escolar: lê respostas dos alunos da sua escola
-- Admin global: acesso total
-- ============================================================
ALTER TABLE public.respostas ENABLE ROW LEVEL SECURITY;

CREATE POLICY "respostas: aluno acessa as próprias"
    ON public.respostas FOR ALL
    USING (
        sessao_id IN (
            SELECT id FROM public.sessoes_simulado
            WHERE aluno_id = public.perfil_id_atual()
        )
    );

CREATE POLICY "respostas: admin_escolar audita alunos da escola"
    ON public.respostas FOR SELECT
    USING (
        sessao_id IN (
            SELECT ss.id FROM public.sessoes_simulado ss
            JOIN public.matriculas m ON m.aluno_id = ss.aluno_id
            WHERE m.escola_id = public.escola_gerenciada_id()
        )
    );

CREATE POLICY "respostas: admin_global acesso total"
    ON public.respostas FOR ALL
    USING (public.papel_atual() = 'admin_global');
