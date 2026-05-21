-- ============================================================
-- SIMULADOR ENEM — 02_triggers.sql
-- Funções e triggers de automação e validação
-- Executar APÓS 01_schema.sql
-- ============================================================

-- ============================================================
-- TRIGGER 1
-- Cria perfil automaticamente ao registrar novo usuário
-- Dispara: AFTER INSERT em auth.users
-- ============================================================
CREATE OR REPLACE FUNCTION public.handle_novo_usuario()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = public
AS $$
BEGIN
    INSERT INTO public.perfis (auth_id, nome_completo, papel)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'nome_completo', 'Novo Usuário'),
        COALESCE(NEW.raw_user_meta_data->>'papel', 'aluno')
    );
    RETURN NEW;
END;
$$;

CREATE TRIGGER ao_criar_usuario
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_novo_usuario();


-- ============================================================
-- TRIGGER 2
-- Valida que o gestor da escola tem papel 'admin_escolar'
-- Dispara: BEFORE INSERT OR UPDATE em escolas
-- ============================================================
CREATE OR REPLACE FUNCTION public.verificar_papel_admin_escolar()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM public.perfis
        WHERE id = NEW.admin_id AND papel = 'admin_escolar'
    ) THEN
        RAISE EXCEPTION 'O gestor da escola deve ter o papel admin_escolar.';
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_verificar_admin_escolar
    BEFORE INSERT OR UPDATE ON public.escolas
    FOR EACH ROW EXECUTE FUNCTION public.verificar_papel_admin_escolar();


-- ============================================================
-- TRIGGER 3
-- Valida que somente usuários com papel 'aluno' são matriculados
-- Dispara: BEFORE INSERT OR UPDATE em matriculas
-- ============================================================
CREATE OR REPLACE FUNCTION public.verificar_papel_aluno()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM public.perfis
        WHERE id = NEW.aluno_id AND papel = 'aluno'
    ) THEN
        RAISE EXCEPTION 'Somente usuários com papel aluno podem ser matriculados.';
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_verificar_aluno
    BEFORE INSERT OR UPDATE ON public.matriculas
    FOR EACH ROW EXECUTE FUNCTION public.verificar_papel_aluno();
