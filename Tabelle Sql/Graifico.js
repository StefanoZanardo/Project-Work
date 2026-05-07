const Card = ({ label, role, type = "group", delay = 0 }) => {
  const styles = {
    ceo: {
      bg: "#1a1a2e", border: "#1a1a2e",
      labelColor: "#ffffff", roleColor: "#aab4c8",
      shadow: "0 6px 24px rgba(26,26,46,0.18)",
      minW: 210, px: 44, py: 20, labelSize: "1.1rem",
    },
    group: {
      bg: "#f0f4ff", border: "#c5d0e8",
      labelColor: "#1a1a2e", roleColor: "#5a6a8a",
      shadow: "0 3px 12px rgba(26,26,46,0.08)",
      minW: 170, px: 30, py: 15, labelSize: "0.95rem",
    },
    cto: {
      bg: "#1a1a2e", border: "#1a1a2e",
      labelColor: "#ffffff", roleColor: "#aab4c8",
      shadow: "0 4px 16px rgba(26,26,46,0.15)",
      minW: 170, px: 30, py: 15, labelSize: "0.95rem",
    },
  };
  const s = styles[type];
  return (
    <div style={{
      background: s.bg,
      border: `1.5px solid ${s.border}`,
      borderRadius: 10,
      padding: `${s.py}px ${s.px}px`,
      minWidth: s.minW,
      textAlign: "center",
      boxShadow: s.shadow,
      animationName: "fadeUp",
      animationDuration: "0.5s",
      animationDelay: `${delay}ms`,
      animationFillMode: "both",
      animationTimingFunction: "ease-out",
    }}>
      <div style={{
        color: s.labelColor,
        fontWeight: 700,
        fontSize: s.labelSize,
        fontFamily: "Georgia, serif",
        letterSpacing: "0.02em",
      }}>{label}</div>
      <div style={{
        color: s.roleColor,
        fontSize: "0.63rem",
        marginTop: 5,
        fontFamily: "'Courier New', monospace",
        letterSpacing: "0.06em",
        textTransform: "uppercase",
      }}>{role}</div>
    </div>
  );
};

const V = ({ h = 36, color = "#b0bcd4" }) => (
  <div style={{ width: 2, height: h, background: color, borderRadius: 2, flexShrink: 0 }} />
);

const Arrow = ({ color = "#9aaac8" }) => (
  <div style={{ display: "flex", flexDirection: "column", alignItems: "center" }}>
    <V h={28} color={color} />
    <div style={{
      width: 0, height: 0,
      borderLeft: "5px solid transparent",
      borderRight: "5px solid transparent",
      borderTop: `6px solid ${color}`,
      marginBottom: 4,
    }} />
  </div>
);

const COL_W = 200;
const GAP = 56;
const TOTAL_W = COL_W * 3 + GAP * 2; // 668
const HALF = TOTAL_W / 2; // 334

export default function OrgChart() {
  return (
    <>
      <style>{`
        @keyframes fadeUp {
          from { opacity: 0; transform: translateY(14px); }
          to   { opacity: 1; transform: translateY(0); }
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
      `}</style>

      <div style={{
        minHeight: "100vh",
        background: "#ffffff",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        justifyContent: "center",
        padding: "52px 40px 60px",
        fontFamily: "Georgia, serif",
      }}>

        {/* Header */}
        <div style={{ textAlign: "center", marginBottom: 48, animationName: "fadeUp", animationDuration: "0.5s", animationFillMode: "both" }}>
          <div style={{
            fontSize: "0.63rem", letterSpacing: "0.22em", textTransform: "uppercase",
            color: "#7a8aaa", fontFamily: "'Courier New', monospace", marginBottom: 8,
          }}>Struttura Organizzativa</div>
          <div style={{
            fontSize: "1.75rem", fontWeight: 700, fontFamily: "Georgia, serif",
            color: "#1a1a2e", letterSpacing: "0.01em",
          }}>Organigramma Aziendale</div>
          <div style={{ width: 52, height: 3, background: "#1a1a2e", borderRadius: 2, margin: "12px auto 0" }} />
        </div>

        {/* Chart wrapper — fixed width so lines never clip */}
        <div style={{ display: "flex", flexDirection: "column", alignItems: "center", width: TOTAL_W }}>

          {/* CEO */}
          <Card label="CEO" role="Chief Executive Officer" type="ceo" delay={100} />

          {/* Vertical stem down from CEO */}
          <V h={36} color="#6677aa" />

          {/* Horizontal bus: spans full TOTAL_W */}
          <div style={{
            width: TOTAL_W,
            height: 2,
            background: "#b0bcd4",
            borderRadius: 2,
            position: "relative",
          }}>
            {/* tick marks at each column centre */}
            {[COL_W / 2, COL_W + GAP + COL_W / 2, COL_W * 2 + GAP * 2 + COL_W / 2].map((x, i) => (
              <div key={i} style={{
                position: "absolute",
                left: x - 3,
                top: -3,
                width: 8, height: 8,
                borderRadius: "50%",
                background: "#b0bcd4",
              }} />
            ))}
          </div>

          {/* Three columns */}
          <div style={{ display: "flex", alignItems: "flex-start", gap: GAP, width: TOTAL_W }}>

            {/* ── Segreteria ── */}
            <div style={{ display: "flex", flexDirection: "column", alignItems: "center", width: COL_W }}>
              <V h={32} color="#b0bcd4" />
              <Card label="Segreteria" role="Gestione Amministrativa" type="group" delay={260} />
            </div>

            {/* ── Commerciali ── */}
            <div style={{ display: "flex", flexDirection: "column", alignItems: "center", width: COL_W }}>
              <V h={32} color="#b0bcd4" />
              <Card label="Commerciali" role="Vendite & Business" type="group" delay={360} />
            </div>

            {/* ── CTO → Programmatori ── */}
            <div style={{ display: "flex", flexDirection: "column", alignItems: "center", width: COL_W }}>
              <V h={32} color="#b0bcd4" />
              <Card label="CTO" role="Chief Technology Officer" type="cto" delay={460} />
              <Arrow color="#9aaac8" />
              <Card label="Programmatori" role="Sviluppo Software" type="group" delay={600} />
            </div>

          </div>
        </div>

        {/* Legend */}
        <div style={{
          marginTop: 52,
          display: "flex",
          gap: 28,
          borderTop: "1px solid #e4e8f0",
          paddingTop: 18,
          animationName: "fadeUp",
          animationDuration: "0.5s",
          animationDelay: "750ms",
          animationFillMode: "both",
        }}>
          {[
            { color: "#1a1a2e", label: "Vertice / Responsabile" },
            { color: "#c5d0e8", label: "Dipartimento" },
          ].map(({ color, label }) => (
            <div key={label} style={{ display: "flex", alignItems: "center", gap: 8 }}>
              <div style={{ width: 14, height: 14, borderRadius: 3, background: color, border: "1px solid #ccc", flexShrink: 0 }} />
              <span style={{ fontSize: "0.68rem", color: "#7a8aaa", fontFamily: "'Courier New', monospace", letterSpacing: "0.06em", textTransform: "uppercase" }}>
                {label}
              </span>
            </div>
          ))}
        </div>

      </div>
    </>
  );
}