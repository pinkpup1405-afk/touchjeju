# CLAUDE.md — Flutter + Supabase 프로젝트 기본 셋팅

## WHAT

Flutter 앱 + Supabase 백엔드. Clean Architecture + GetX 패턴.
서버는 별도 구현 없이 Supabase(Auth, Postgres, Storage, Realtime, Edge Functions)로 대체.

```
lib/
├── feature/              # 기능별 모듈 (Clean Architecture)
│   └── {feature}/
│       ├── data/         # DataSource(Supabase 쿼리), Repository 구현체
│       ├── domain/       # Entity, UseCase, Repository 인터페이스
│       └── presentation/ # Controller, View, Binding
├── core/                 # navigator, design_system, config, supabase 초기화
├── common/               # foundation, network, domain, widget
├── services/             # 앱 서비스 (Auth, Push 등)
└── shared/               # 디자인 시스템, 분석(Amplitude 등)

supabase/                 # Supabase CLI 프로젝트 (로컬 개발/마이그레이션)
├── migrations/           # SQL 마이그레이션 (스키마 변경은 반드시 여기로)
├── functions/            # Edge Functions (Deno/TypeScript)
└── config.toml
```

## 레이어 역할

| 레이어 | 역할 |
|--------|------|
| Domain | 순수 비즈니스 로직, Supabase/Flutter 독립 |
| Data | Supabase 쿼리, DTO ↔ Entity 변환 |
| Presentation | UI 상태관리 (GetX) |

## 주요 패키지

```yaml
dependencies:
  supabase_flutter: ^2.x      # Auth + DB + Storage + Realtime
  get: ^4.x                   # 상태관리 / 라우팅 / DI
  get_it: ^8.x                # DI 컨테이너
  injectable: ^2.x            # DI 코드 생성
  json_annotation: ^4.x
  envied: ^1.x                # 환경변수 (컴파일 타임 난독화)

dev_dependencies:
  build_runner: ^2.x
  injectable_generator: ^2.x
  json_serializable: ^6.x
  envied_generator: ^1.x
```

## 초기 셋팅 순서

### 1. Supabase 프로젝트

```bash
# CLI 설치 (없으면)
brew install supabase/tap/supabase

# 로그인 & 프로젝트 연결
supabase login
supabase init                  # supabase/ 폴더 생성
supabase link --project-ref <PROJECT_REF>

# 로컬 개발 스택 (Docker 필요)
supabase start
```

### 2. 환경변수

`.env` 파일 (git에 절대 커밋 금지):

```
SUPABASE_URL=https://xxxx.supabase.co
SUPABASE_ANON_KEY=eyJ...
```

`.gitignore`에 추가:

```
.env
*.env
lib/**/env.g.dart
```

envied로 컴파일 타임 주입:

```dart
// lib/core/config/env.dart
@Envied(path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'SUPABASE_URL')
  static final String supabaseUrl = _Env.supabaseUrl;
  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  static final String supabaseAnonKey = _Env.supabaseAnonKey;
}
```

> anon key는 클라이언트 노출 전제 키. 보안은 키 은닉이 아니라 **RLS로** 담보한다.
> `service_role` 키는 절대 앱에 넣지 않는다 (Edge Function 전용).

### 3. Supabase 초기화

```dart
// main.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );
  runApp(const App());
}

// 전역 접근 (data 레이어에서만 사용)
final supabase = Supabase.instance.client;
```

## HOW (자주 쓰는 명령)

```bash
# 의존성 설치
fvm flutter pub get

# 코드 생성 (Entity, Env, DI 등)
fvm dart run build_runner build --delete-conflicting-outputs

# 분석 / 테스트
fvm flutter analyze
fvm flutter test

# 빌드
fvm flutter build ios --release
fvm flutter build appbundle --release

# --- Supabase ---
supabase start                          # 로컬 스택 기동
supabase migration new <name>           # 새 마이그레이션 생성
supabase db push                        # 원격에 마이그레이션 적용
supabase db reset                       # 로컬 DB 초기화 + 마이그레이션 재적용
supabase gen types dart --linked > lib/core/supabase/db_types.dart  # 타입 생성
supabase functions serve <fn>           # Edge Function 로컬 실행
supabase functions deploy <fn>          # Edge Function 배포
```

## 핵심 규칙

1. **Entity**: `@immutable` + `@JsonSerializable()`, `.generated/` 폴더에 생성. DB row ↔ Entity 매핑은 data 레이어에서만.
2. **UseCase**: `@Injectable()`, 단일 책임.
3. **Repository**: Interface(domain) + Impl(data) 분리, `@Injectable(as: Interface)`.
4. **DataSource**: Retrofit Provider 대신 Supabase 쿼리 클래스. `supabase.from('table')` 호출은 여기서만. Controller/UseCase에서 직접 Supabase 호출 금지.
5. **Controller**: GetxController, `Rx<>` 상태, UseCase 주입 via `inject()`.
6. **Binding**: `Get.lazyPut<Controller>()`.
7. **RLS 필수**: 모든 테이블에 Row Level Security 활성화 + 정책 작성 후에만 클라이언트 접근 허용. RLS 없는 테이블은 배포 금지.
8. **스키마 변경은 마이그레이션으로만**: 대시보드에서 직접 수정 금지, `supabase migration new` → SQL 작성 → `db push`.
9. **Realtime 구독 해제**: `RealtimeChannel`은 컨트롤러 `onClose()`에서 반드시 `unsubscribe()`.
10. **Rx 메모리 해제**: 컨트롤러에서 선언한 Rx 필드는 `onClose()`에서 항상 해제.

## 새 기능 생성 순서

1. **DB**: 마이그레이션 작성 (테이블 + RLS 정책) → `supabase db push`
2. **Domain**: Entity → Repository Interface → UseCase
3. **Data**: DataSource(Supabase 쿼리) → Repository Impl
4. **Presentation**: Controller → Binding → View
5. build_runner 실행

## 상태 관리

`ViewStatus` enum (idle, initializing, loading, success, failure, empty)

## Auth 패턴

```dart
// 세션 감지 (services/auth_service.dart)
supabase.auth.onAuthStateChange.listen((data) {
  switch (data.event) {
    case AuthChangeEvent.signedIn: ...
    case AuthChangeEvent.signedOut: ...
    default: break;
  }
});
```

- 소셜 로그인(Apple/Google/Kakao)은 `signInWithOAuth` + 딥링크 리다이렉트 사용.
- iOS: `Info.plist`에 URL Scheme 등록 / Android: `AndroidManifest.xml`에 intent-filter 등록.
- 세션은 supabase_flutter가 자동 영속화(secure storage) — 별도 토큰 저장 로직 만들지 않는다.

## 개발 관련 사항

1. 코드 생성 후 build_runner 필요 시 자동 실행
2. 서버 로직이 필요하면(결제 검증, 서드파티 API 호출 등) 클라이언트가 아닌 Edge Function으로 구현
3. Storage 업로드 경로는 `{bucket}/{user_id}/...` 규칙 + Storage 정책으로 본인 경로만 접근 허용
