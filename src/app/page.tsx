"use client";
import { useCallback, useEffect, useState } from "react";
import Link from "next/link";
import { ArrowRight, ArrowUpRight, Check, CircleDot, Clock3, Home, Leaf, LoaderCircle, MapPin, MessageCircle, Plus, Radio, RefreshCw, Sparkles, X } from "lucide-react";
import type { Answer, Expectation, Snapshot } from "@/lib/types";

type State = Omit<Snapshot, "events"> & { today: string; briefing: string; config: { ringMode: "fixture" | "ring"; ringDeviceMode: "configured" | "playground"; aiMode: "fixture" | "bedrock"; timeZone: string } };
async function request<T>(url: string, body?: unknown): Promise<T> {
  const response = await fetch(url, body === undefined ? { cache: "no-store" } : { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(body) });
  const data = await response.json();
  if (!response.ok) throw new Error(data.error || "Something went wrong.");
  return data;
}
export default function Around() {
  const [state, setState] = useState<State>();
  const [bedrockToken, setBedrockToken] = useState("");
  const [tab, setTab] = useState("Home"), [tell, setTell] = useState(false), [sentence, setSentence] = useState("");
  const [question, setQuestion] = useState(""), [answer, setAnswer] = useState<Answer>(), [saved, setSaved] = useState<Expectation>();
  const [busy, setBusy] = useState(""), [error, setError] = useState(""), [notice, setNotice] = useState("");
  const refresh = useCallback(async () => setState(await request<State>("/api/state")), []);
  useEffect(() => {
    let active = true;
    request<State>("/api/state").then(data => { if (active) setState(data); }).catch(e => { if (active) setError(e.message); });
    return () => { active = false; };
  }, []);
  async function action(name: string, work: () => Promise<void>) {
    setBusy(name); setError(""); setNotice("");
    try { await work(); } catch (e) { setError(e instanceof Error ? e.message : "The request failed."); } finally { setBusy(""); }
  }
  async function askQuestion(text: string) {
    setQuestion(text); setAnswer(undefined);
    await action("ask", async () => setAnswer(await request<Answer>("/api/ask", { text, ...(bedrockToken ? { bedrockToken } : {}) })));
  }
  function openTell() { setTell(true); setSaved(undefined); setSentence(""); setError(""); }
  const time = (value: string) => new Intl.DateTimeFormat("en-US", { hour: "numeric", minute: "2-digit", timeZone: state?.config.timeZone || "America/New_York" }).format(new Date(value));
  const date = state ? new Intl.DateTimeFormat("en-US", { weekday: "long", month: "long", day: "numeric", timeZone: "UTC" }).format(new Date(`${state.today}T12:00:00Z`)) : "Your home at a glance";
  return <div className="shell">
    <aside className="sidebar">
      <Link href="/" className="brand" aria-label="Around home"><span className="brand-mark"><Radio size={25}/></span>around<span className="brand-period">.</span></Link>
      <div className="home-label"><span className="home-icon"><Home size={17}/></span><div>My home<small>A little more in the know</small></div></div>
      <nav aria-label="Main navigation">
        <button className={tab === "Home" ? "nav-active" : ""} onClick={() => setTab("Home")}><Home size={19}/>Home</button>
        <button onClick={openTell}><MessageCircle size={19}/>Tell Around<Plus size={15} className="nav-plus"/></button>
        <button className={tab === "Activity" ? "nav-active" : ""} onClick={() => setTab("Activity")}><CircleDot size={19}/>Activity</button>
      </nav>
      <div className="sidebar-note"><Leaf size={21}/><p>Your home has a story.<br/>Keep up with the little things.</p></div>
      <div className="sidebar-bottom"><span className="status-dot"/>A home, a little clearer.</div>
    </aside>
    <main>
      <header className="topbar"><span><MapPin size={14}/> My home</span><button className="icon-button" aria-label="Refresh activity" disabled={!!busy} onClick={() => action("refresh", refresh)}><RefreshCw size={16}/></button></header>
      <div className="content">
        <div className="page-heading"><div><p className="eyebrow">{date}</p><h1>{tab === "Home" ? "Home, in the know." : "The story around your home."}</h1><p className="subtitle">{tab === "Home" ? "A little context. A clearer picture of your day." : "Related moments, brought together into meaningful activity."}</p></div><button className="primary tell-trigger" onClick={openTell}><Plus size={17}/>Tell Around</button></div>
        {error && <div role="alert" className="error"><span>{error}</span><button aria-label="Dismiss error" onClick={() => setError("")}><X size={16}/></button></div>}
        {notice && <p role="status" className="notice"><Check size={16}/>{notice}</p>}
        {!state ? <div className="empty"><LoaderCircle className="spin"/>Loading your home...</div> : <>
          <section className="source-banner" aria-label="Demo data source"><div><strong>{state.config.ringMode === "fixture" ? "Sample activity" : state.config.ringDeviceMode === "playground" ? "Ring Playground activity" : "Ring activity"}</strong><p>{state.config.ringMode === "fixture" ? "A demonstration scenario. These events were not received from Ring." : state.config.ringDeviceMode === "playground" ? "Official Ring API records. A live-view request does not confirm a visitor." : "Activity received through the official Ring API."}</p></div><span>{state.config.aiMode === "bedrock" ? "Amazon Bedrock" : "Local demo answers"}</span></section>
          {tab === "Home" && <>
            <section className="ask-card" aria-labelledby="ask-title"><div className="section-kicker"><Sparkles size={17}/> AROUND IS HERE TO HELP</div><h2 id="ask-title">What would you like to know?</h2><p>Ask about a visit, or catch up on what happened.</p>
              <form onSubmit={e => { e.preventDefault(); askQuestion(question); }}><label className="sr-only" htmlFor="ask">Ask Around</label><input id="ask" value={question} maxLength={600} onChange={e => setQuestion(e.target.value)} placeholder="Did the plumber come?" required/><button disabled={!!busy || !question.trim()} aria-label="Ask Around" type="submit">{busy === "ask" ? <LoaderCircle className="spin" size={20}/> : <ArrowRight size={20}/>}</button></form>
              <div className="suggestions">{state.config.ringMode === "ring" && <button disabled={!!busy} onClick={() => askQuestion("What did Ring record?")}>What did Ring record?<ArrowUpRight size={13}/></button>}<button disabled={!!busy} onClick={() => askQuestion("Did the plumber come?")}>Did the plumber come?<ArrowUpRight size={13}/></button><button disabled={!!busy} onClick={() => askQuestion("Anything I should know?")}>Anything I should know?<ArrowUpRight size={13}/></button></div>
            </section>
            {answer && <section className="answer-card" aria-live="polite"><div className="section-kicker"><Radio size={16}/> AROUND</div><p>{answer.text}</p>{answer.evidence.length > 0 && <details><summary>Based on {answer.evidence.length} saved records</summary><ul>{answer.evidence.map((e, i) => <li key={`${e.id}-${i}`}>{e.label}</li>)}</ul></details>}<small>{answer.source === "fixture" ? "Sample activity" : "Recorded Ring activity"} · {answer.engine === "bedrock" ? "Amazon Bedrock" : "Local demo answer"}</small></section>}
            <section className="briefing"><div className="briefing-symbol"><Sparkles size={22}/></div><div><div className="briefing-heading"><h2>Anything I should know?</h2><span className="pill">TODAY</span></div><p>{state.briefing}</p></div></section>
          </>}
          <div className={tab === "Home" ? "overview-grid" : "activity-full"}>
            <section aria-labelledby="activity-title"><div className="section-heading"><h2 id="activity-title">Recent activity</h2><span>{state.activities.length} {state.activities.length === 1 ? "activity" : "activities"}</span></div>
              {!state.activities.length ? <div className="empty activity-empty"><span className="empty-icon"><CircleDot size={26}/></span><h3>A quiet page, for now.</h3><p>When activity comes in, Around brings the related moments together here.</p></div> : <div className="activity-list">{state.activities.map(a => {
                const matches = state.matches.filter(m => m.activityId === a.id), likely = matches.length === 1 && matches[0].confidence >= 0.6;
                const expectation = likely ? state.expectations.find(e => e.id === matches[0].expectationId) : undefined;
                return <article className="activity-card" key={a.id}><div className="activity-icon"><Home size={20}/></div><div className="activity-body"><div className="activity-title"><h3>{a.label}</h3><span className="tiny-label">{a.source === "fixture" ? "SAMPLE" : "RING"}</span></div><p className="activity-time"><Clock3 size={13}/>{time(a.startedAt)}{a.endedAt ? ` to ${time(a.endedAt)}` : a.type === "live_view" ? "" : " onward"}<span>· {new Intl.DateTimeFormat("en-US", { month: "short", day: "numeric", timeZone: state.config.timeZone }).format(new Date(a.startedAt))}</span></p><p>{a.summary}</p>{expectation && <div className="matched"><Check size={14}/>Likely matches your {expectation.personOrService} visit</div>}{matches.some(m => m.confidence < 0.6) && <div className="uncertain">Several expectations or visits fit this window.</div>}<details><summary>{a.eventIds.length} related {a.eventIds.length === 1 ? "moment" : "moments"} · {a.locationName}</summary><p>{a.type === "live_view" ? "This is a live-view request, not a motion detection or visitor identification. " : a.endedAt ? "Times estimate the bounds of the grouped activity, not continuous presence. " : "Departure is not established. "}{matches[0]?.explanation || "No expectation matched this activity."}</p></details></div></article>;
              })}</div>}
            </section>
            <section aria-labelledby="expected-title"><div className="section-heading"><h2 id="expected-title">Expected activity</h2><button onClick={openTell} aria-label="Add expected activity"><Plus size={18}/></button></div>
              <div className="expectations">{!state.expectations.length ? <div className="empty"><Clock3 size={24}/><h3>Expecting someone?</h3><p>Tell Around about an upcoming visit. We’ll help you connect the dots.</p><button className="text-button" onClick={openTell}>Add an expectation<ArrowRight size={14}/></button></div> : state.expectations.map(e => <article className="expectation-card" key={e.id}><span className={`expectation-status ${e.status === "likely_match" ? "matched-status" : ""}`}>{e.status === "likely_match" ? "Likely visited" : e.status === "ambiguous" ? "Uncertain match" : "Expected"}</span><h3 className="capitalize">{e.personOrService} visit</h3><p>{e.expectedDate === state.today ? "Today" : e.expectedDate} · {e.startWindow} to {e.endWindow}</p><p className="original-text">“{e.originalText}”</p></article>)}</div>
            </section>
          </div>
          <section className="demo-panel"><div><span className="tiny-label">{state.config.ringMode === "fixture" ? "LOCAL DEMO" : state.config.ringDeviceMode === "playground" ? "RING PLAYGROUND" : "RING CONNECTION"}</span><p>{state.config.ringMode === "fixture" ? "Try a day around your home." : "Bring in your latest Ring activity."}</p><small>{state.config.ringMode === "fixture" ? "Play four sample moments: driveway, front door, then departure." : state.config.ringDeviceMode === "playground" ? "Live-view requests are shown as live views. They do not confirm a visitor." : "Sync history from your configured devices. Webhooks appear after refresh."}</small>{state.config.ringMode === "ring" && state.devices.length > 0 && <small className="connected-devices">{state.devices.length} {state.devices.length === 1 ? "device" : "devices"} received from Ring: {state.devices.map(d => d.name).join(", ")}</small>}</div>
            <form className="sync-form" autoComplete="off" onSubmit={e => {
              e.preventDefault(); const form = e.currentTarget;
              const accessToken = String(new FormData(form).get("accessToken") || "").trim();
              form.reset(); setAnswer(undefined);
              action("sync", async () => {
                const result = await request<{ changed: number; devices: number }>("/api/ring/sync", accessToken ? { accessToken } : {});
                await refresh();
                setNotice(result.changed ? `${result.changed} moments received and grouped.` : "Already up to date. No duplicate moments were added.");
              });
            }}>
              {state.config.ringMode === "ring" && <><label htmlFor="ring-token">Temporary Ring access token</label><input id="ring-token" name="accessToken" type="password" maxLength={16000} autoComplete="off" placeholder="Paste token for this sync" disabled={!!busy}/><small>Used for this sync only. Around does not save it. Leave blank to use server configuration.</small></>}
              <button className="secondary" type="submit" disabled={!!busy}>{busy === "sync" ? <LoaderCircle className="spin" size={16}/> : <Radio size={16}/>} {state.config.ringMode === "fixture" ? "Play sample visit" : "Sync Ring activity"}</button>
            </form></section>
          {state.config.aiMode === "bedrock" && <section className="demo-panel"><div><span className="tiny-label">AMAZON BEDROCK</span><p>Temporary demo connection</p><small>Held in this page until cleared or reloaded. Used for Tell and Ask requests. Around does not save it.</small></div><div className="sync-form"><label htmlFor="bedrock-token">Temporary Bedrock API key</label><input id="bedrock-token" type="password" autoComplete="off" maxLength={16000} value={bedrockToken} onChange={e => setBedrockToken(e.target.value)} disabled={!!busy} placeholder="Paste a temporary API key"/><small>Leave blank to use server credentials.</small><button className="secondary" disabled={!!busy || !bedrockToken} onClick={() => setBedrockToken("")}>Clear Bedrock key</button></div></section>}
          <footer><span>around. <span className="footer-tagline">Spatial intelligence for your home.</span></span><span>{state.config.ringMode === "fixture" ? "Sample data" : "Ring API"} · {state.config.aiMode === "fixture" ? "Local demo language" : "Amazon Bedrock"} · {state.config.timeZone}</span></footer>
        </>}
      </div>
    </main>
    {tell && <div className="modal-backdrop"><section className="tell-modal" role="dialog" aria-modal="true" aria-labelledby="tell-title" onKeyDown={e => { if (e.key === "Escape" && !busy) setTell(false); }}><button className="close-modal icon-button" disabled={!!busy} aria-label="Close Tell Around" onClick={() => setTell(false)}><X size={20}/></button><div className="modal-symbol"><MessageCircle size={24}/></div><p className="eyebrow">A LITTLE HEADS-UP GOES A LONG WAY</p><h2 id="tell-title">Tell Around.</h2><p>Who or what are you expecting? Give us a date and a time window.</p>{saved ? <div className="saved-card"><span className="matched"><Check size={16}/>Expectation saved</span><h3 className="capitalize">{saved.personOrService} visit</h3><p>{saved.expectedDate} · {saved.startWindow} to {saved.endWindow}</p><p>{saved.location}</p><button className="primary" onClick={() => { setTell(false); setTab("Home"); }}>Back to my home<ArrowRight size={16}/></button></div> : <form onSubmit={e => { e.preventDefault(); action("save", async () => { const result = await request<{ expectation: Expectation }>("/api/expectations", { text: sentence, ...(bedrockToken ? { bedrockToken } : {}) }); setSaved(result.expectation); setAnswer(undefined); await refresh(); }); }}><label className="sr-only" htmlFor="expectation">What are you expecting around your home?</label><textarea id="expectation" autoFocus required maxLength={600} placeholder="What are you expecting around your home?" value={sentence} onChange={e => setSentence(e.target.value)}/>{state?.config.aiMode === "fixture" && <button type="button" className="example" onClick={() => setSentence("The plumber is coming today between 10 and 1.")}>Try: The plumber is coming today between 10 and 1.</button>}<button className="primary save-button" disabled={!!busy || !sentence.trim()}>{busy === "save" ? <LoaderCircle className="spin" size={16}/> : <Plus size={16}/>}Save expectation</button></form>}{error && <p role="alert" className="modal-error">{error}</p>}<small>{state?.config.aiMode === "bedrock" ? "Your sentence is sent to Amazon Bedrock to understand the visit." : "Local demo: the sample sentence works without a cloud connection."}</small></section></div>}
  </div>;
}
