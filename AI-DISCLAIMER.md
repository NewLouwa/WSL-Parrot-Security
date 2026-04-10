# AI Disclosure

This project was built with the help of [Claude Code](https://claude.ai) (Anthropic's AI coding assistant).

What would have taken me weeks of scripting, testing, writing 90+ tool docs, and debugging bash edge cases took about a night. I'm not going to pretend otherwise — AI made this possible at this speed.

But I think it's worth talking about what that actually means.

---

## AI in hacking and security — the honest version

Here's the thing nobody wants to say out loud:

**AI will make you faster. It won't make you better.**

You can ask ChatGPT to write you a reverse shell one-liner, explain a CVE, or generate a Python exploit. And it'll work. But the day your internet goes down, or you're in an exam with no AI access, or you're on an engagement with no tokens left — you're on your own. And "I usually ask Claude for that" isn't an answer your client wants to hear.

I use AI the same way I use the tools in this toolkit: to save time on stuff I already understand, or to learn something new faster. Not to skip the learning entirely.

### The good

If you're using AI to:
- **Understand** how a tool works → great, that's learning faster
- **Generate** a script you'll actually read, understand, and modify → solid, that's productivity
- **Get unstuck** on something you've been debugging for hours → yeah, we've all been there
- **Explore** a topic you don't know where to start with → that's what it's for

### The bad

If you're using AI to:
- **Copy-paste exploits** without understanding what they do → you're going to brick something or worse, miss what's actually going on
- **Skip the fundamentals** because "AI can do it" → good luck on your OSCP
- **Replace your own thinking** → congrats, you're now a very expensive clipboard

AI is a force multiplier. But you can't multiply by zero.

---

## How to actually use AI while learning (without screwing yourself over)

This is the part most people skip. Using AI while learning is fine — if you do it right. The problem isn't the tool, it's how people use it. Here's what actually works:

### 1. Try it yourself first, then check

Before you ask AI anything, spend at least 15-20 minutes struggling with it yourself. Google it. Read the error message. Try a different flag. Check the man page (or the .md docs in this repo — that's why they exist). Write down what you've tried and what you think the problem is. Take a break, come back, look at it fresh. I swear it helps — your brain keeps working on it in the background.

When you're actually stuck, don't go straight to "give me the answer." Ask for a **hint**. Ask "what direction should I look in?" instead of "fix this for me." Ask "what tool would help me do X?" instead of "here's what I have, do it for me." Put your thinking down first — even if it's wrong — and ask AI to tell you where your reasoning breaks. That's how you actually get better at this stuff.

The difference matters: if you struggled first, the answer will actually stick. If you didn't, you'll forget it in 10 minutes and ask the same thing next week.

### 2. Never copy-paste without reading every single line

This is the golden rule. If AI gives you a command or a script:
- **Read it.** You don't need to memorize every flag — nobody does, that's what docs are for. But you should get the general idea of what it's doing and why. If you see a flag you don't recognize, look it up. Takes 10 seconds.
- **Would you run it on a real engagement?** If you don't understand what a command does, the answer is no. Not "probably fine," not "it worked on HTB" — no.

Copying a reverse shell payload you don't understand is the same energy as running a random .exe from a Discord server. Don't be that person.

### 3. Explain it back to yourself

After AI explains something to you, close the chat and try to explain it to yourself — out loud, in your notes, whatever works. Like you're teaching it to someone else. If you can't, you didn't understand it — you just read it. There's a massive difference.

This is the technique that actually builds knowledge. It's annoying. It's slow. It works.

Seriously — get a note-taking tool and use it. [Obsidian](https://obsidian.md/), [Notion](https://www.notion.so/), [CherryTree](https://www.giuspen.net/cherrytree/), even a physical notebook. Write down what you learn, organize it, link concepts together. Mind maps are insanely underrated for this — seeing how things connect makes the knowledge stick in a way that reading never will. Your future self doing a box at 3 AM will thank you when the answer is already in your notes instead of buried in a chat history you can't find anymore.

### 4. Use AI to understand errors, not to fix them blindly

When something breaks, don't just paste the error and say "fix this." Instead:
- Ask "what does this error mean?"
- Ask "why is this happening?"
- Ask "what should I look for?"

Then fix it yourself. The goal is to understand the problem, not to make the red text go away. If you just want the red text to go away, you're not learning — you're doing tech support with extra steps.

### 5. Do it manually first, automate later

If you've never done an nmap scan by hand, don't start with an AI-generated scanning script. If you've never cracked a hash with john manually, don't ask AI for a "full automated cracking pipeline."

The manual pain is the learning. Once you've done it enough times to be annoyed by the repetition — that's when automation and AI make sense. Not before.

### 6. Test yourself without AI regularly

Shut it off sometimes. Do a box on HTB without any AI help. Time yourself. See where you get stuck. Those stuck points are exactly what you need to study — and now you actually know what you don't know instead of having AI cover your blind spots.

If you can't do it without AI, you can't do it. Period.

---

## On this project specifically

I could have built this entire toolkit by hand. I've been doing HTB on and off for a few years, I know these tools, I know what I need in my workflow. But writing 90+ documentation files, debugging bash edge cases across different shells, and structuring everything neatly — that's not skill work, that's grunt work. AI is perfect for grunt work.

The decisions — which tools to include, how to organize them, what the workflow should look like, what actually matters when you're sitting in front of a box at 2 AM — those are mine. AI didn't decide that. A human who's been frustrated by reinstalling the same tools for the fifth time decided that.

That's the difference between using AI as a tool and using AI as a brain replacement.

This toolkit will keep evolving based on what I actually need and what the community asks for — if it ever gets one. The tool list, the workflow, the docs — none of that is set in stone. It started from my own frustrations, and if other people use it and have different ones, it'll grow from that too. That's the whole point of open-source.

---

## TL;DR

- Yes, AI helped build this. A lot.
- AI is a tool. Use it like one — don't let it use you.
- Learn the basics manually. Struggle. Break things. Then use AI to go faster.
- If you can't do it without AI, you can't do it.
- The people who will be the best in this field in 5 years are the ones who use AI to learn faster, not the ones who use AI to skip learning.

### Personal note

Back in 2012 — when the world was supposedly ending — I dreamed about becoming a web developer. I'm fucking glad I didn't. Don't get me wrong, web devs do great work, and if I had a company I'd definitely hire a few alongside designers and webmasters. But let's be real: a lot of that work is what I'd call grunt work now. And AI is eating grunt work for breakfast.

These days when I need something built for a project, I use AI and it saves me 100x the time. But here's the key — I know how it works. I know how to steer it. I can look at what it generated and go "why the fuck are you storing user data in a plain JSON with unsalted hashes?" I know enough about dev to catch that, to redirect it, to know when it's cutting corners. That's not expert-level knowledge — that's just having solid basics and caring enough to check.

The same thing is coming for cybersecurity. Red team, blue team, doesn't matter — AI is getting integrated into everything. SOC analysts are already using it for triage. Pentesters are using it for recon automation. It's not replacing anyone yet, but it's reshaping every workflow.

So learn how to use it. Get comfortable with it. Make it part of your toolkit. But **never stop learning the fundamentals yourself.** Because the day AI gives you a wrong answer — and it will — you need to be the one who catches it. Not the other way around.

---

*This project is open-source because sharing tools makes the community stronger. AI helped build it, but a human decided what to build, why, and how it should work. The day AI can feel the frustration of reinstalling aircrack-ng for the 12th time, it can take over. Until then, it's my assistant — not my replacement.*
