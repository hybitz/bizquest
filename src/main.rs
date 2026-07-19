use std::net::SocketAddr;

use axum::Router;
use tower_http::{
    services::{ServeDir, ServeFile},
    trace::TraceLayer,
};

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt()
        .with_env_filter(
            tracing_subscriber::EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| "info,tower_http=info".into()),
        )
        .init();

    let port: u16 = std::env::var("PORT")
        .ok()
        .and_then(|p| p.parse().ok())
        .unwrap_or(3000);

    // /assets/* -> webpack/sass のビルド成果物 (app/assets/builds)
    // それ以外   -> public/ (ルートは public/index.html、見つからなければ public/404.html)
    let app = Router::new()
        .nest_service("/assets", ServeDir::new("app/assets/builds"))
        .fallback_service(
            ServeDir::new("public").not_found_service(ServeFile::new("public/404.html")),
        )
        .layer(TraceLayer::new_for_http());

    let addr = SocketAddr::from(([0, 0, 0, 0], port));
    let listener = tokio::net::TcpListener::bind(addr)
        .await
        .unwrap_or_else(|e| panic!("failed to bind {addr}: {e}"));
    tracing::info!("bizquest server listening on http://{addr}");

    axum::serve(listener, app)
        .with_graceful_shutdown(shutdown_signal())
        .await
        .expect("server error");
}

async fn shutdown_signal() {
    let ctrl_c = async {
        tokio::signal::ctrl_c()
            .await
            .expect("failed to install Ctrl+C handler");
    };

    #[cfg(unix)]
    let terminate = async {
        tokio::signal::unix::signal(tokio::signal::unix::SignalKind::terminate())
            .expect("failed to install SIGTERM handler")
            .recv()
            .await;
    };

    #[cfg(not(unix))]
    let terminate = std::future::pending::<()>();

    tokio::select! {
        _ = ctrl_c => {},
        _ = terminate => {},
    }
}
